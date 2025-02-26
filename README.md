# Kitchen

[![Tests](https://github.com/openstax/kitchen/workflows/Tests/badge.svg)](https://github.com/openstax/kitchen/actions?query=workflow:Tests)
[![Coverage Status](https://img.shields.io/codecov/c/github/openstax/kitchen.svg)](https://codecov.io/gh/openstax/kitchen)

Kitchen lets you modify the structure and content of XML files.  You create a `Recipe` with instructions and `bake` it in the `Oven`.

[Full documentation at rubydoc.info](https://rubydoc.info/github/openstax/kitchen).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'openstax_kitchen'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install openstax_kitchen

## Two Ways to Use Kitchen

There are two ways to use Kitchen: the "generic" way and the "book" way.  The generic way provides mechanisms for traversing and modifying an XML document.  The book way extends the generic way by adding mechanisms that are specific to the book content XML produced at OpenStax (e.g. the book way knows about chapters and pages, figures and terms, etc, whereas the generic way does not have this knowledge).

We'll first talk about the generic way since those tools are also available in the book way.

## Generic Usage

Kitchen lets you modify the structure and content of XML files.  You create a `Recipe` and `bake` it in the `Oven`:

```ruby
require "openstax_kitchen"

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
new_html = doc.clipboard(name: :my_special_clipboard).paste
```

`cut` puts the element on the clipboard and removes the original from the document.  `copy` leaves the element in the document and puts a copy of the element on the clipboard.

Instead of using named clipboards, you can also pass any `Clipboard` object to these methods:

```ruby
my_clipboard = Clipboard.new
doc.search("div.example").each do |div|
  div.cut(to: my_clipboard)
end

new_html = my_clipboard.paste
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
doc.search("span").first.prepend(child: "<br/>")
```

```ruby
# <div><span>Hi</span></div> => <div><div></div><span>Hi</span></div>
doc.search("span").first.prepend(sibling: "<div>")
```

```ruby
# <div><span>Hi</span></div> => <div><span>Hi<br/></span></div>
doc.search("span").first.append(child: "<br/>")
```

```ruby
# <div><span>Hi</span></div> => <div><span>Hi</span><p/></div>
doc.search("span").first.append(sibling: "<p/>")
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

or wrap an element's children:

```ruby
# <div><span>Hi</span></div> => <div><span><span class="other" data-type="foo">Hi</span></span></div>
doc.search("span").first.wrap_children('span', class: 'other', data_type: 'foo')
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

Sometimes, it is difficult to setup a search using CSS.  In such cases, you can also pass `only` and `except` arguments to search methods, e.g.:

```ruby
doc.book.figures(except: :subfigure?)
```

`only` and `except` can be the names of methods (that return truthy/falsy values) on the element being iterated over, as shown above, or they can be lambdas or procs as shown here:

```ruby
doc.book.figures(only: ->(fig) { fig.children.count == 2 })
```

Obviously this is a somewhat contrived example, but the idea is that by passing a callable you can do complex searches.

### Overriding Default Book-Oriented Selectors

Book-oriented methods like `book.pages.figures` hide from us the CSS or XPath selectors that let us find child elements like `.pages`.  But sometimes, the default selector we have isn't what is used in a certain book.  In these cases, we can override the selector once in the recipe and still continue to use the book-oriented usage.  For example, a page summary is normally found using the CSS `section.summary`.  But some books use a `.section-summary` class.  For these books, we can override the selectors in their recipes:

```ruby
recipe = Kitchen::BookRecipe.new do |doc|
  doc.selectors.override(
    page_summary: ".section-summary"
  )
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

### Building HTML strings

There are a number of valid ways of building up HTML strings to insert into documents.

Maybe you have a tiny bit of HTML to add and you can use vanilla Ruby strings:

```ruby
some_element.append(child: "<br/>")
```

You can continue doing this with multiline strings but it gets to be a pain -- you have to add your own newlines (`\n`) and line continuation symbols (`\`):

```ruby
some_element.append(child: "first line\n" \
                           "second line")
```

Ruby has a much better way of handling multiline strings: [heredocs](https://ruby-doc.org/core-2.5.0/doc/syntax/literals_rdoc.html#label-Here+Documents).  The best of these is the "squiggly" heredoc, which captures string content between `<<~SOME_ARBITRARY_TEXT` and `SOME_ARBITRARY_TEXT`:

```ruby
some_element.append(sibling: <<~HTML
    <div class="os-caption-container">
      <span class="os-caption">Awesomeness</span>
    </div>
  HTML
)
```

The squiggly heredoc removes the shortest leading indentation from each line.  It lets you use single and double quotes inside the string without escaping them.  And at least in certain editors when you use `HTML` as your "some arbitrary text", you'll get HTML syntax highlighting.  You can also do interpolate variables into the string using `#{some_variable}` The above example is equivalent to this Ruby string written in the earlier approach:

```ruby
"<div class=\"os-caption-container\">\n" \
"  <span class=\"os-caption\">Awesomeness</span>\n" \
"</div>\n"
```

The big downside to all of these approaches is that for more complicated strings, we often need to use some Ruby logic to build up different parts of the string, and the techniques above don't allow for that.

Let's invent an example of needing to build some HTML that had a listing of all chapter titles in a bulleted list and then their page titles within them in a nested bulleted list (kind of like a table of contents).  This is an example of what we'd be shooting for:

```html
<ul>
  <li>
    <span>Chapter 1 Title</span>
    <ul>
      <li><span>Page 1.1 Title</span></li>
      <li><span>Page 1.2 Title</span></li>
    </ul>
  </li>
  <li>
    ... etc etc
  </li>
</ul>
```

Here's one way we could build up this string using squiggly heredocs:

```ruby
class SomethingThatBakes
  def bake(doc)
    @book = doc.book

    chapter_bullets_array = @book.chapters.map do |chapter|
      page_bullets_array = chapter.pages.map do
        <<~HTML
          <li><span>#{page.title.text}</span></li>
        HTML
      end

      <<~HTML
        <li>
          <span>#{chapter.title.text}</span>
          <ul>
            #{page_bullets_array.join("\n")}
          </ul>
        </li>
      HTML
    end.join("\n")

    final_string = <<~HTML
      <ul>#{chapter_bullets_array.join("\n")}</ul>
    HTML

    # do something with that final_string
  end
end
```

The above works but it is a little fragmented to read.  We have to build up parts of the bulleted lists in arrays, then join them together with newlines and embed them in other strings (some of which are also collected in an array and then later substituted and joined).

For these more complex strings we have another option: [ERB (Embedded RuBy)](https://www.stuartellis.name/articles/erb/).  ERB is part of standard Ruby and had its heyday when Rails came out in the 2000s.  ERB lets us make a separate HTML file with Ruby sprinkled within it.  Let's call this file `blah.html.erb`:

```erb
<ul>
  <% @book.chapters.each do |chapter| %>
    <li>
      <span><%= chapter.title.text</span>
      <ul>
        <% chapter.pages.each do |page| %>
          <li><span><%= page.title.text %></span></li>
        <% end %>
      </ul>
    </li>
  <% end %>
</ul>
```

In our Ruby class doing the generation, we add a `renderable` statement at the top code we can then say:

```ruby
class SomethingThatBakes
  renderable

  def bake(doc)
    final_string = render(file: 'blah.html.erb')

    # do something with that final_string
  end
end
```

This ERB approach is a lot easier to read -- you can see the nesting structure directly in the template file.  The Ruby code in the ERB template will have access to any instance variable in the code that called it, i.e. the variables that start with `@`.

The `render` method takes a `file` argument that is a string file path.  If the path is relative, it is relative to the directory in which the `render` call is made.

If you want to make relative file paths be relative to a different directory, you can pass a directory string to the `renderable` statement: `renderable dir: '/Some/other/directory'`.

Again, all these techniques work and there are times to use them all.

## One-file scripts

Want to make a one-file script to do some baking?  Use the "inline" form of bundler:

```ruby
#!/usr/bin/env ruby

require "bundler/inline"

gemfile do
  gem 'openstax_kitchen', '2.0.0'
end

require "openstax_kitchen"

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

You can use Docker for your development environment.  To build the image:

```bash
$> ./docker/build
```

To drop into the running container:

```bash
$> ./docker/bash
```

To run specs (or something else) from the host:

```bash
$> ./docker/run rspec
```

To run a specific spec, reference the line where the test starts:

```bash
$> ./docker/run rspec spec/recipes_spec/main_spec.rb:116
```

### Non-Docker

After checking out the repo, run `bin/setup` to install dependencies.  If you want to install this gem onto your local machine, run `bundle exec rake install`.

### Console

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

### Tutorials

There are some tutorials you can work through in the `tutorials` directory.  Each tutorial is in a separated numbered subdirectory, e.g. `tutorials/01`.  Each tutorial directory contains a `raw.html` file that is your starting point (along with some instructions in comments at the top), an `expected_baked.html` file that is what you're trying to get to when your recipe is applied to the input file, as well as some number of solution files (don't look at those unless you get stuck!!).  To get started, run:

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

There is normally more than one way to achieve the desired output, so feel free to diverge from what is shown in the solution files.  Note that the `my_recipe.rb` files and all `actual_baked.html` files are ignored by Git.

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

### Releases

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Documentation

Documentation is handled via YARD.  The [Solargraph gem](https://solargraph.org/guides/getting-started) can be used in popular editors for code completion.

Run `yard server --reload` to watch for changes in your local codebase everytime you refresh the page.

Navidate to `http://localhost:8808/` to view documentation in your browser.

Use the `inch` gem to get feedback on where documentation is lacking `bundle exec inch` (add `--help` for more options).

### Specs

Run `bundle exec rspec` to run the specs.  `rake rspec` probably does the same thing.

Spec offers 3 ways to compare expected XML output to actual output.

`match_snapshot_auto` generates a snapshot file and compares the test output to it using [rspec-snapshot](https://github.com/levinmr/rspec-snapshot). To update the snapshots, run `UPDATE_SNAPSHOTS=true rspec`

`match_normalized_html` gets rid of extra blanks, sorts all tag attributes alphabetically by attribute name (e.g. sorts "<a href='blah' class='foo'>" to "<a class='foo' href='blah'>" so that attribute order doesn't impact a match), prints the HTML back out with a standard indent, and then does a normal string diff.

```ruby
expect(book_1).to match_normalized_html("some string of HTML here")
```

`match_html_nodes` does a node-by-node diff using the `nokogiri-diff` gem.  It gives more specific node diff data but is also not quite as clear.

```ruby
expect(book_1).to match_html_nodes("some string of HTML here")
```

#### More on snapshots

Autogenerated snapshot files are created by composing the path with the name of the test. Be aware of collisions (i.e. better to use `'v1 works'`, `'v2 works'`, etc than just `'works'` when deal with multiple versions).

When the expected output is less than 3 lines or so, inline matching with `match_normalized_html` is preferred. Any long expected output block should get a snapshot.

### Profiling

If you set the `PROFILE` environment variable to something before you run specs or a recipe, search query profile data will be collected and printed, e.g.

```bash
%> PROFILE=1 rspec
```

### Caching

There's a low-level CSS query caching tool that saves repeated queries.  In some tests, it saves 15% of query time.  It is disabled by default (because we aren't super sure that it is completely safe) but can be turned on with

```ruby
doc.config.enable_search_cache = true
```

### VSCode

1. Visit `vscode:extension/ms-vscode-remote.remote-containers` in a browser
2. It'll open VSCode and bring you to an extension install screen, click "Install"
3. Click the remote button now in the bottom left hand corner.
4. Click "Remote-Containers: Open Folder in Container"
5. Select the cloned kitchen folder.

This (assuming you have Docker installed) will launch a docker container for Kitchen, install Ruby and needed libraries, and then let you edit the code running in that container through VSCode.  Solargraph will work (code completion and inline documentation) as will Rubocop for linting.

### Rubocop

Rubocop is good for helping us keep our code style standardized, but it isn't the end-all be-all of things.  We can disable certain checks within a file, e.g.

```ruby
# rubocop:disable Style/NumericPredicate
```

or we can disable or change global settings in the `.rubocop.yml` file.

Rubocop is setup to run within the VSCode dev container (see above).

The [lefthook](https://github.com/Arkweid/lefthook) is included in the Docker build.  When you push your code to GitHub, lefthook runs Rubocop on all the files you have changed.  It won't let you push if you have Rubocop errors.  You'll have to fix the errors or make changes to the `.rubocop.yml` files to bypass the errors.  You can also run lefthook directly with

```bash
$ /code> lefthook run pre-push
```

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

## Tools

Helpful scripts in the `bin` directory:

* `normalize` - Normalizes content files to make it easier to compare them.  E.g. if you want to compare kitchen baked output to cnx-recipes baked output, you should normalize the files first.  `normalize somefile.xhtml` produces `somefile.normalized.xhtml` which has its attributes sorted by attribute name, copied element ID numbers masked (because they change based on order of operations in recipes, but their values are not important), and some errors in legacy baked files removed (e.g. unnumbered tables get a `summary` attribute with a bogus number).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## TODO

* Specs galore :-)
* Think up and handle a bunch more recipe errors, test they all raise some kind of `RecipeError`.
* Encapsulate numbering schemes (e.g. chapter pages are "5.2", appendix pages are "D7") and maybe set on book document?  Right now we are doing inline things like `*('A'..'Z')][page.count_in(:book)-1]}#{table.count_in(:page)` which is ugly.
* Control I18n language in Oven.
* README: element_children, .only, selectors, config files
* Use ERB for more readable string building?

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







# OpenStax Book Recipes

Uses the `openstax_kitchen` gem to bake OpenStax books.

## Recipe File Structure

In this repo, we have (at least) one recipe for every book.  There's a `books/` directory in which we have subfolders, one for each book.  In those subfolders, we put an executable Ruby file, normally named `bake` but it could be anything.  (Later if you want to make a new recipe for the book you could name it `bake_new` or whatever in the same directory).

The executable `bake` Ruby scripts will typically have everything they need inside of them, e.g. they'll look like this:

```ruby
#!/usr/bin/env ruby

require "bundler/inline"

gemfile do
  gem 'openstax_kitchen', '2.0.0'
  gem 'slop', '4.8.2'
  gem 'byebug'
end

recipe = Kitchen::BookRecipe.new(book_short_name: :chemistry) do |doc|
  # ... RECIPE CODE HERE ...
end

opts = Slop.parse do |slop|
  slop.string '--input', 'Assembled XHTML input file', required: true
  slop.string '--output', 'Baked XHTML output file', required: true
end

puts Kitchen::Oven.bake(
  input_file: opts[:input],
  recipes: recipe,
  output_file: opts[:output]
)
```

Normal big Ruby projects have a `Gemfile` that is processed by the `bundler` gem to install and use all the right versions of any gems your code depends on.  Here we're using [bundler's ability](https://bundler.io/guides/bundler_in_a_single_file_ruby_script.html) to include a `gemfile` directly in the source code.  We're only using a few gems, so this is doable.  It is also makes the script nicely self-contained.  Because inline gem declarations like this don't have a `Gemfile.lock` that locks down the versions of gems (like other bigger Ruby projects), we want to make sure we use specific versions of gems e.g. `'1.0.1'` and not `'~> 1.0.0'`.

`Slop` is a simple command line argument parser.  Here it lets us call this `bake` script with `--input some_file.xhtml` and `--output other_file.xhtml` arguments that are passed into the `Kitchen::Oven.bake` call along with the recipe this script defines.  The `Kitchen::Oven.bake` method returns some profiling numbers that we output to the screen using `puts`.

## The main `bake` script

The top-level `bake` Bash script calls the right scripts in the `books` folder based on the book slug.  E.g. if you call `./bake -b chemistry -i in.xhtml -o out.xhtml` this script will call `./books/chemistry/bake --input in.xhtml --output out.xhtml`.  Every time we add a new recipe, we'll need to update this top-level bake script so it knows how to call it.  This is also why the names of the scripts inside `/books` don't really matter, because the top-level `bake` script knows the names of the lower-level scripts.

The main pipeline (`enki`) calls `bake` in the `git-bake` (or `archive-bake`) step.

## The `shorten` script

This script generates shortened content for a book. It calls the book-specific shorten script in `books/{book-name}/shorten` to generate a shortened version of the assembled file, then bakes this file with kitchen, and normalizes. Essentially, it bundles calls to three other scripts: the book-specific `shorten`, the book-specific `bake`, and `normalize`. The output files are written to the `data/{book-name}/short/` directory.

Call this script with `./shorten -b <bookname> -i <inputfile>`. Add `USE_LOCAL_KITCHEN=1` at the beginning to bake with the local version of kitchen.

It is assumed that the given `<bookname>` will match the folder name for the book in the `/books/` directory.

As with the main `bake` script, new books must be added to [the case statement](/shorten#L21), ex:

```bash
case "${book}" in
  chemistry) dest="${DIR}/data/chemistry/short" && script="${DIR}/books/chemistry/shorten";;
    ... [other cases]
  {book-name}) dest="$DIR/data/{book-name}/short"  && script="${DIR}/books/{book-name}/shorten";;
  *) echo "Unknown book '${book}'"; exit 1;;
esac
```

### Book-specific `shorten` scripts

Each book has its own directions to create a shortened version for development and testing purposes. This script is in `books/{book-name}/shorten`. It uses the kitchen framework and `Oven.bake` to remove parts of the book and generate output, but it does not yield a baked book.

## Docker

Development and execution can be done using Docker.

To build the docker image:

```bash
$> ./docker/build
```

Note this builds the runtime environment, suitable for running in production and some development work.  If you want a more full development environment, use VS Code using the remote containers extension.  This will build the development environment with a nice terminal, VS Code Live Share for pairing, etc.  To install the remote containers extension, visit `vscode:extension/ms-vscode-remote.remote-containers` in a browser.

To drop into the Docker container:

```bash
$> ./docker/bash
```

To use the Docker image to bake input XHTML files do the following (you can do it all on one line, just put it on multiple lines here to describe each part):

```bash
$> docker run --rm \                                                                # Remove container after the run
              -v $PWD:/files \                                                      # Mount the current host directory as /files so we can put files
                                                                                    #   in and get them out
              openstax/recipes:latest \                                             # The image ID (could use a specific tagged image instead of "latest")
              /code/bake -b chemistry -i /files/input.xhtml -o /files/baked.xhtml # The call to the main `bake` script
```

The above runs the baking in the latest (or some tagged) image.  If you want to run using your latest recipe code on your local machine, you can mount that code in the container by adding another `-v` argument: `-v /path/to/my/local/recipes:/code`.

Want to run the recipes and do interactive debugging?  Add the `-it` flags to the `docker run` call above.

## Rubocop

Rubocop is available inside the VSCode dev container.  Moreover, the `lefthook` gem enforces that Rubocop linting passes on modified files before pushes are allowed.  To test this without pushing run `lefthook run pre-push`.

## Using your local git clone of kitchen within the recipes devcontainer

If you put the absolute path of your machine's cloned kitchen folder into a `.devcontainer/kitchen_path` text file, e.g.:

```
/Users/staxly/dev/openstax/kitchen
```

the devcontainer in VS Code will mount that folder to `/code/kitchen`.  This will let you look at and edit the code from within your VS Code recipes workspace and will let you point recipes at this local code with

```ruby
gem 'openstax_kitchen', path: '/code/kitchen'
```

so that you can develop in both recipes and kitchen at the same time.  The kitchen folder has its own independent git state.

If you don't have a `kitchen_path` file, the devcontainer will mount a fake empty directory in `/tmp`.

If you use a line like the following in your recipe script to choose the kitchen gem version:

```ruby
gem 'openstax_kitchen', ENV['USE_LOCAL_KITCHEN'] ? { path: '/code/kitchen' } : '2.0.0'
```

And then call the recipe script prefixed with defining the `USE_LOCAL_KITCHEN` variable:

```bash
$ /code> USE_LOCAL_KITCHEN=1 ./books/chemistry2e/bake ...
```

then your recipe will use your local kitchen folder.  You can leave the `gem` line as is when you commit it, and in production runs since the `USE_LOCAL_KITCHEN` environment variable isn't set, the version number at the end will be used.

## Starting a recipe

The `create_new_recipe` script offers a quickstart way to generate many of the initial files for recipe development, like the locale files and the boilerplate for the bake script. It also adds the relevante line to main `bake`. Call it with `ruby scripts/create_new_recipe <recipe-name> <...>`.

Devs will still need to edit/create:
- `shorten`
- `main_spec`
- test data for specs

## Creating a new recipe manually

New recipes files are created in `lib/recipes/{book-name}`.

In order to run the new recipe via the bake script, the recipe must be added to [the `case` statement](https://github.com/openstax/recipes/blob/main/bake#L25), i.e.:

```bash
case "${book}" in
  chemistry) $DIR/books/chemistry/bake --input $input_file --output $output_file;;
  ... [other cases]
  {book-name}) $DIR/books/{book-name}/bake --input $input_file --output $output_file;;
  *) echo "Unknown book '${book}'"; exit 1;;
esac
```

Note that the recipe file must be made executable by running `chmod +x [path]` or `chmod 755 [path]` before it can be called by the bake script.

## Working on a recipe (converting from easybake)

When developing a recipe that already exists in easybake, the main goal is to produce output via the kitchen recipe that is identical to the easybake output. It's helpful to use VSCode's native differ or another diff tool to compare the output from the two methods of baking.

### Normalize

The kitchen output and the easybake output may have a number of unimportant differences such as in whitespace and the ordering of attributes. The `normalize` script tidies the HTML and puts all attributes in alphabetical order. Call this script on an HTML file by calling `ruby scripts/normalize [path]`.

## Book-specific locale files

A book may contain translations specific to itself (i.e., the note title 'Portrait of a Chemist' only appears in Chemistry). To solve this problem, locales specific to the book may be created. A recipe has the ability to receive a custom locales path, or infer the location of the locales directory as long as this directory is stored next to the bake file. For example, the recipe in `books/chemistry/bake` would look for a directory called `books/chemistry/locales`. This locale file does not permanently modify the I18n backend and only persists for as long as the recipe runs, so no need to worry about conflicts with other books' locales.

### Specs for recipes

When the book-specific recipe is done, we can create a spec for it. The way specs are done is by comparing the baked file to an expected output file via the md5 hex.

1) Create a folder under `spec/books/{book-name}` with a file called `input.xhtml` and another file called `expected_output.xhtml` inside it. As a suggestion, the `input` file could contain the content inside the `assembled.xhtml` file and the `expected_output` file could contain the content inside the `normalized` version of the kitchen-baked file, so `kitchen-baked.normalized.xhtml`, both of these files are generated by the shorten script, but the important thing is that the `input` and `expected_output` exist and are useful test data.

2) Create an entry on the `spec/main_spec.rb` file like:
  ```ruby
  it 'bakes {book-name}' do
    expect('{book-name}').to bake_correctly
  end
  ```
  the `{book-name}` should match the `book directory` where the `match_helper.rb` can find the recipe for it,
  this is done by `bake_correctly`.

3) If you wish to run local kitchen for the spec to succeed, you can do `USE_LOCAL_KITCHEN=1 rspec`, if you want to run it with the current version of kitchen, make sure you have the right version at the top of your recipe like:
`gem 'openstax_kitchen', ENV['USE_LOCAL_KITCHEN'] ? { path: '/code/kitchen' } : '3.2.0'` or, instead of a version, you can set it to a specific `sha` of a branch.
