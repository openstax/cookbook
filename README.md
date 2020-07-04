# Kitchen

[![Build Status](https://travis-ci.org/openstax/kitchen.svg?branch=master)](https://travis-ci.org/openstax/kitchen)

Kitchen lets you modify the structure and content of XML files.  You create a `Recipe` with instructions and `bake` it in the `Oven`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kitchen'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install kitchen

## Two Ways to Use Kitchen

There are two ways to use Kitchen: the "generic" way and the "book" way.  The generic way provides mechanisms for traversing and modifying an XML document.  The book way extends the generic way by adding mechanisms that are specific to the book content XML produced at OpenStax (e.g. the book way knows about chapters and pages, figures and terms, etc, whereas the generic way does not have this knowledge).

We'll first talk about the generic way since those tools are also available in the book way.

## Generic Usage

Kitchen lets you modify the structure and content of XML files.  You create a `Recipe` and `bake` it in the `Oven`:

```ruby
require "kitchen"

recipe = Kitchen::Recipe.new do |document|
  document.search("div.section").each do |element|
    element.name = "section"
    element.remove_class("section")
  end
end

Kitchen::Oven.bake(
  input_file: "some_file.xhtml",
  recipes: recipe,
  output_file: "some_other_file.xhtml"
)
```

The above example changes all `<div class="section">` tags to `<section>`.

The `document` above is a `Kitchen::Document` and the `element` is a `Kitchen::Element`.  Both have methods for reading and manipulating the XML.  You can of course name the block argument whatever you want (see examples below).

### The `search` method and enumerators

`search` takes one or more CSS and XPath selectors and returns an enumerator that iterates over the matching elements inside the document or element that `search` is called on.

The enumerator that is returned is an `ElementEnumerator` which is a subclass of Ruby's [`Enumerator`](https://ruby-doc.org/core-2.6/Enumerator.html).  Enumerators are also [`Enumerable`](https://ruby-doc.org/core-2.6/Enumerable.html) which gives you a bunch of methods you can call on enumerators like:

* `count` - get the number of matching elements
* `map` - form a new array using the matching elements
* `each` - do something with each matching element
* `first` - return the first matching element
* [etc etc](https://ruby-doc.org/core-2.6/Enumerable.html)

Here's an example calling `search` on a document and then calling `each` on its result:

```ruby
doc.search("div.example").each do |div| # find all "div.example" elements in the document
  div.add_class("foo")                  # add a class to each of those elements
  div.search("p").each do |p|           # find all "p" elements inside the "div.example" elements
    p.name = "div"                      # change them to "div" tags
  end
end
```

### Clipboards, cut, copy, and paste

When baking our content, we often want to move content around or make copies of content to reuse elsewhere in the document.  Kitchen provides clipboard functionality to help with this.

Every document holds a set of named clipboards.  You can `cut` and `copy` to these named clipboards:

```ruby
doc.search("div.example").each do |div|
  div.cut(to: :my_special_clipboard)
end
```

```ruby
doc.first("p").copy to: :foo
```

And then in some code where you are building up a string of HTML to insert you can

```ruby
new_html = doc.clipboard(name: :my_special_clipboard).paste}
```

`cut` puts the element on the clipboard and removes the original from the document.  `copy` leaves the element in the document and puts a copy of the element on the clipboard.

Instead of using named clipboards, you can also pass any `Clipboard` object to these methods:

```ruby
my_clipboard = Clipboard.new
doc.search("div.example").each do |div|
  div.cut(to: my_clipboard)
end

new_html = new_clipboard.paste
```

This is often the better way to go because if you use the named ones in the document you have to remember to `clear` them before you use it to not get stuck with whatever you left there the last time you used it.

`ElementEnumerator` also provides extra clipboard-related methods to make your life easier.  Instead of writing

```ruby
doc.search("div.example").each do |div|
  div.cut(to: :my_special_clipboard)
end
```

You can say

```ruby
doc.search("div.example").cut(to: :my_special_clipboard)
```

The same applies to `copy` and these methods also work with passed-in `Clipboard` objects.  If you don't pass in a clipboard name or a `Clipboard` object, these methods return a new `Clipboard` containing the cut or copied content:

```ruby
a_new_clipboard = doc.search("div.example").cut
```

Clipboards are also `Enumerable` so you can call the enumerable methods (`count`, `each`, etc) on them.

When elements that were copied are pasted (or when elements that were cut are pasted more than once), Kitchen will update the IDs of pasted elements to keep them unique.  Kitchen adds `_copy_1`, `_copy_2`, etc to IDs to make this happen.  The `_copy_` prefix is configurable (or at least close to it).

If you want to remove an element (or all elements matched by an enumerator) but NOT put those elements on a clipboard, you can use the `trash` method:

```ruby
some_div.trash
doc.search(".not_needed").trash
```

### Pantries

A document also gives you access to named pantries.  A pantry is a place to store items that you can label for later retrieval by that label.

```ruby
doc.pantry.store "some text", label: "some label"
doc.pantry.get("some label") # => "some text"
```

The above uses the `:default` pantry.  You can also use named pantries:

```ruby
doc.pantry(name: :figure_titles).store "Moon landing", label: "id42"
```

### Counters

Oftentimes we need to count things in a document, for example to number chapters and pages.  A document provides named counters:

```ruby
doc.counter(:chapter).increment
doc.counter(:chapter).get
doc.counter(:chapter).reset
```

See book-oriented usage for a better way of counting elements.

### Adding content

In kitchen we can prepend or append element children or siblings:

```ruby
# <div><span>Hi</span></div> => <div><span><br/>Hi</span></div>
doc.search("span").first.prepend child: "<br/>"
```

```ruby
# <div><span>Hi</span></div> => <div><br/><span>Hi</span></div>
doc.search("span").first.prepend sibling: "<div></div>"
```

```ruby
# <div><span>Hi</span></div> => <div><span>Hi<br/></span></div>
doc.search("span").first.append child: "<br/>"
```

```ruby
# <div><span>Hi</span></div> => <div><span>Hi</span><br/></div>
doc.search("span").first.append sibling: "<p/>"
```

We can also replace all children:

```ruby
# <div><span>Hi</span></div> => <div><span><p>Howdy</p></span></div>
doc.search("span").first.replace_children with: "<p>Howdy</p>"
```

And we can wrap an element with another element:

```ruby
# <div><span>Hi</span></div> => <div><span class="other"><span>Hi</span></span></div>
doc.search("span").first.wrap("<span class='other'>")
```

### Checking for elements

You can see if an element contains an element matching a selector:

```ruby
my_element.contains?(".title") #=> true or false
```

### Miscellaneous

* `ElementEnumerator` also provides a `first!` method that is like the standard `first` except it raises an error if there is no matching first element to return.

### Using `raw` to get at underlying Nokogiri objects.

Kitchen uses the Nokogiri gem to parse and manipulate XML documents.  `Document` objects wraps a `Nokogiri::XML::Document` object, and `Element` objects wrap a `Nokogiri::XML::Node` object.  If you want to do something wild and crazy you can access these underlying objects using the `raw` method on `Document` and `Element`.  Note that many of the methods on the underlying objects are exposed on the Kitchen object, e.g. instead of saying `my_element.raw['data-type']` you can say `my_element['data-type']`.

## Book-Oriented Usage

All of the above works, but it is generic and we have a specific problem handling books that use a specific schema.  To that end, Kitchen also includes a `BookDocument` to use in place of `Document` as well as elements and enumerators specific to this schema, e.g. `BookElement`, `ChapterElement`, `PageElement`, `TableElement`, `FigureElement`, `NoteElement`, `ExampleElement`.  `BookDocument` has a method called `book` that returns a `BookElement` that wraps the top-level `html` element.  All of these elements have methods on them for searching for other of these specific elements, so that instead of

```ruby
doc.book.search("[data-type='page']")
```

we can say

```ruby
doc.book.pages
```

In the generic usage, you can chain `search` methods:

```ruby
doc.book.search("[data-type='page']").search("figure")
```

will find all figure elements inside pages inside `my_chapter`.

In the book-oriented usage, you can chain specific search methods to achieve the same effect:

```ruby
doc.book.pages.figures
```

This chaining of enumerators gives other benefits.  The above search for figures will yield figures that know the page they were found in as well as their numerical position within that page.  So you could do something like this:

```ruby
doc.book.chapters.pages.figures.each do |figure|
  figure.prepend(child:
    "<span class='os-number'>Figure #{figure.count_in(:chapter)}.#{figure.count_in(:page)}</span>" \
    "<span class='os-title'>A figure in chapter #{figure.ancestor(:chapter).title}</span>"
  )
end
```

This finds all figures that are in pages that are in chapters in the book.  The `count_in` methods on the figure give the number position of the figure element within the chapter or page so we can form a figure number like "2.13".  And as seen here, chapter elements (instances of `ChapterElement`) have a `title` method that returns the title text for the chapter.  Figures have a `caption` element, etc.

The CSS for these specific search methods is hidden away so you don't have to deal with it.  But if you want to customize that CSS you can.  You can pass an overriding CSS selector to these methods, and if you use the `$` character in that argument the search method will replace it with the normal CSS selector, e.g. if you wanted to get rid of all of the table elements that have the "unnumbered" class you could say:

```ruby
doc.book.tables("$.unnumbered").cut
```

## Directions

All of the above talks about the how to search through the XML file and perform basic operations on that file.  Our recipes will be combinations of all of the above: search for elements; cut, copy and paste them; count them; rework them; etc.

One recipe for processing a book probably does 10-30 different kinds of operations: format and number tables, same for figures and examples, number and organize exercises and their solutions in different parts of the book, build chapter glossaries, build an index, build a table of contents, etc, etc.

We're not going to want to write out all of those steps in every receipe.  Instead it'd be a better idea to write out each step in its own little piece of code.  With the steps isolated from each other we'll be dealing with less code all at once and it'll be much easier to write tests to exercise that code.

In Kitchen, we've started the process of writing out these steps and we've put them in a `directions` folder (which is also a `Directions` module).  E.g. `Kitchen::Directions::BakeChapterSummary` modifies a provided chapter to have a chapter summary at the end.

It is probably true that the `BakeChapterSummary` code will work for some number of books, but other books might have different requirements.  As such we can expect that there will be different variants of the chapter summary baking step.  To anticipate this, our first implementation of this step lives in a method named `v1` (so to run it you call `BakeChapterSummary.v1(chapter: some_chapter)`).  Later if there's a tweak needed that can't fit into v1's approach, we can make a `v2` method that could live in its own file.  This may or may not be the right approach to handle this kind of code variation, but it is at least a place to start.

### Internationalization (I18n)

Recognizing that our books will be translated into multiple languages, Kitchen has support for internationalization (I18n).  There's a spot for translation files in the `locales` directory, in which there is currently one `en.yml` translation file for English.  Within our directions code you'll see uses of it like here to title an Example:

```erb
<span class="os-title-label">#{I18n.t(:example)} </span>
```

## One-file scripts

Want to make a one-file script to do some baking?  Use the "inline" form of bundler:

```ruby
#!/usr/bin/env ruby

require "bundler/inline"

gemfile do
  gem 'kitchen', git: 'https://github.com/openstax/kitchen.git', ref: 'some_sha_here'
end

require "kitchen"

recipe = Kitchen::Recipe.new do |doc|
  # ... recipe steps here
end

Kitchen::Oven.bake(
  input_file: "some_file.xhtml",
  recipes: recipe,
  output_file: "some_other_file.xhtml")
)
```

Incidentally, the `bake` method returns timing information, if you `puts` its result you'll see it.

## Recipe (and Gem) Development

### Docker

You can use Docker for your development environment.

```bash
$> docker-compose up -d
```

to build and run the Docker container, then:

```bash
$> ./docker/bash
```

To drop into the container at the command line.

### Non-Docker

After checking out the repo, run `bin/setup` to install dependencies.  If you want to install this gem onto your local machine, run `bundle exec rake install`.

### Console

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

### Tutorials

There are some tutorials you can work through in the `tutorials` directory.  Each tutorial is in a separated numbered subdirectory, e.g. `tutorials/01`.  Each tutorial directory contains an `input.xhtml` file that is your starting point (along with some instructions in comments at the top), an `expected_output.xhtml` file that is what you're trying to get to when your recipe is applied to the input file, as well as some number of solution files (don't look at those unless you get stuck!!).  To get started, run:

```bash
$> ./setup_my_recipes
```

in the `tutorials` directory.  That will make a blank `my_recipe.rb` file in each of the numbered tutorial subdirectories.  This is where you'll do your work.  The first "Hello world!" tutorial ("00") asks you to make a recipe that changes

```html
<div class="hello">
  <span>Planet?</span>
</div>
```

to

```html
<h1 class="hello">
  <span>World!</span>
</h1>
```

There's an included script to check to see if your recipe achieves the desired transformation:

```bash
$> ./check_it 00
```

Will check to see if your `tutorials/00/my_recipe.rb` file does what is needed.  If it does, you'll see a "way to go" message.  If it doesn't, you'll see a diff between the expected output and the actual output.  E.g. if you run `./check_it 00` without having done any work yet, you'll see:

```bash
The actual output does not match the expected output.
- = actual output
+ = expected output

@@ -1,4 +1,4 @@
-<div class="hello">
-  <span>Planet?</span>
-</div>
+<h1 class="hello">
+  <span>World!</span>
+</h1>
```

The `check_it` script can also check the solutions.  E.g. if you say

```bash
$> ./check_it 00 solution_1
```

you'll see

```bash
The actual output matches the expected output! Way to go!
```

There is normally more than one way to achieve the desired output, so feel free to diverge from what is shown in the solution files.  Note that the `my_recipe.rb` files and all `actual_output.xhtml` files are ignored by Git.

**Important:** If things aren't working in your tutorial work (or actually in any recipe work), use the `debugger`!  Just add a `debugger` line anywhere in your code to stop execution there so you can poke around.  You can print variables by typing out their name, run methods on objects, say `s` to step into function calls, `n` ("next") to step over function calls, `b 97` to set a new breakpoint at line 97, and `c` to continue to the next debugger statement, breakpoint, or the end of the script.

### Error Messages

Kitchen tries to give helpful error messages instead of huge stack traces, e.g.:

```
The recipe has an error: undefined method `bleach' for main:Object
at or near the following highlighted line

-----+ ./my_work/test.rb -----
   17|
   18|   doc.chapters.each do |chapter|
   19|     chapter.bleach("div.exercise") do |elem|
   20|       elem.first("h3").trash
   21|       elem.cut to: :review_questions

Encountered on line 64 in the input document on element:
<div data-type="chapter">...</div>
```

If you'd still like the huge stack trace, you can set the `VERBOSE` environment variable to anything, e.g.

```bash
$> VERBOSE=1 ./my_work/test.rb
```

### Comparing old recipe output to new

When comparing new baking output to legacy baking output, I have found it useful to prepare the files before applying a standard diff:

1. Parse the documents ignoring blank elements. (this one may not be that important actually)
2. Traverse the documents, sorting their attributes alphabetically by attribute name.
3. Writing the output back out with a standardized indentation scheme.

I have some code to do this, I'll try to get it into this repo.

### Releases

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Documentation

Documentation is handled via YARD.  The [Solargraph gem](https://solargraph.org/guides/getting-started) can be used in popular editors for code completion.

### Specs

Run `bundle exec rspec` to run the specs.  `rake rspec` probably does the same thing.

Spec offer two ways to compare expected XML output to actual output.

`match_normalized_html` gets rid of extra blanks, sorts all tag attributes alphabetically by attribute name (e.g. sorts "<a href='blah' class='foo'>" to "<a class='foo' href='blah'>" so that attribute order doesn't impact a match), prints the HTML back out with a standard indent, and then does a normal string diff.

```ruby
expect(book_1).to match_normalized_html("some string of HTML here")
```

`match_html_nodes` does a node-by-node diff using the `nokogiri-diff` gem.  It gives more specific node diff data but is also not quite as clear.

```ruby
expect(book_1).to match_html_nodes("some string of HTML here")
```

### VSCode

1. Visit `vscode:extension/ms-vscode-remote.remote-containers` in a browser
2. It'll open VSCode and bring you to an extension install screen, click "Install"
3. Click the remote button now in the bottom left hand corner.
4. Click "Remote-Containers: Open Folder in Container"
5. Select the cloned kitchen folder.

This (assuming you have Docker installed) will launch a docker container for Kitchen, install Ruby and needed libraries, and then let you edit the code running in that container through VSCode.  Solargraph will work (code completion and inline documentation).

#### Misc References

* https://marketplace.visualstudio.com/items?itemName=castwide.solargraph
* https://github.com/castwide/solargraph/issues/211
* https://github.com/castwide/vscode-solargraph/issues/7
* https://solargraph.org/guides/yard
* https://code.visualstudio.com/docs/remote/containers
* https://stelligent.com/2020/04/10/development-acceleration-through-vs-code-remote-containers-setting-up-a-foundational-configuration/
* https://code.visualstudio.com/docs/remote/containers#_attaching-to-running-containers
* https://code.visualstudio.com/docs/remote/containers#_attached-container-config-reference

## Tutorials

* Fix up tutorials and describe how to use them here

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/openstax/kitchen. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/openstax/kitchen/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## TODO

* Right now, all specific search methods (e.g. `.pages`) are available on all element types and enumerator
types.  Change this so that you can't do something like `book.pages.chapters`.  But do allow `book.search("arbitrary").pages`.
* Figure out an approach for passing specific selectors into the book when it is parsed (so that things
like `ChapterElement` and `ChapterElementEnumerator` don't have hardcoded selectors in them).
* Make a clean way to search for all of one kind of element that may or may not be inside another element, e.g.
have a nice way to iterate through all pages that may or may not be in chapters with the ability to get the chapter element for those pages in chapters.  Right now we can say `book.search("[data-type='page'], [data-type='chapter'] > [data-type='page']")` which gives us all those pages but doesn't track ancestry or counts well.  Maybe something like `book.either{*|chapters}.pages.each...`
* Add code coverage tracking
* Convert all hardcoded inserted words into I18N translations.
* Redo tutorials for the new way
* Specs galore :-)
  * `$` search path substitution (making sure not to mess up xpath)
* Think up and handle a bunch more recipe errors, test they all raise some kind of `RecipeError`.
* Encapsulate numbering schemes (e.g. chapter pages are "5.2", appendix pages are "D7") and maybe set on book document?  Right now we are doing inline things like `*('A'..'Z')][page.count_in(:book)-1]}#{table.count_in(:page)` which is ugly.
* Add rubocop for linting.
* Finish adding Yard documentation
* Use Yard documentation when printing error debug info. (https://stackoverflow.com/a/25947541)
* Change `search` methods (and related) to also take an `as:` argument.  Use this "as" to name the found elements in search histories instead of using a name based on the search CSS.
* Control I18n language in Oven.
* Get doc normalization scripts into this repo from testkitchen (for comparing two large baked outputs).

## Quirks

When Kitchen writes out HTML containing unicode characters it uses the hexadecimal form, whereas current CE baking uses the decimal form.  I haven't found an internal way to change how Kitchen's underlying library writes these characters, so if you need to do a new-to-old comparison, you can use a few lines of ruby to do a search and replace:

```ruby
original_output = File.read("kitchen_output.xhtml")
modified_output = original_output.gsub(/&#x([0-9A-F]+);/){"&##{$1.hex};"}
File.open("kitchen_output.xhtml", "w") {|file| file.puts modified_output}
```

If this difference matters (if we need the decimal version), we can do more work to figure out a better implementation.

## Ideas

* Use [tmux](https://github.com/tmuxinator/tmuxinator) for real-time evaluation of recipes to see output within one split terminal (source XML in one pane, recipe in middle, output on right).

## Code of Conduct

Everyone interacting in the Kitchen project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/openstax/kitchen/blob/master/CODE_OF_CONDUCT.md).
