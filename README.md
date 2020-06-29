# Kitchen

...

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kitchen'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install kitchen

## Usage

Kitchen lets you modify the structure and content of XML files.  You create a `Recipe` and `bake` it in the `Oven`:

```ruby
require "kitchen"

recipe = Kitchen::Recipe.new do |document|
  document.each("div.section") do |element|
    element.name = "section"
  end
end

Kitchen::Oven.bake(
  input_file: "some_file.xhtml",
  recipes: recipe,
  output_file: "some_other_file.xhtml"
)
```

The above example changes all `<div class="section">` tags to `<section class="section">`.

The `document` above is a `Kitchen::Document` and the `element` is a `Kitchen::Element`.  Both have methods for reading and manipulating the XML.  You can of course name the block argument whatever you want (see examples below).

### Methods in both `Document` and `Element`

#### `each`

`each` iterates over elements matching the provided CSS selector or xpath argument, yields those elements to a block of code.  Other iterators with their own selectors can be nested in that block and their results will be limited to the elements inside the elements found above them.

```ruby
doc.each("div.example") do |div| # find all "div.example" elements
  div.add_class("foo")           # add a class to each of those elements
  div.each("p") do |p|           # find all "p" elements inside "div.example" elements
    p.name = "div"               # change them to "div" tags
  end
end
```

#### `first`

`first` is like `each` except it only works on the first element found with the provided selector, not on all elements found.

`first!` is the same as `first` except it errors if no matching element is found.

#### `raw`

The `raw` method exposes the underlying Nokogiri object, either `Nokogiri::XML::Document` or `Nokogiri::XML::Node` if you want to do something wild and crazy.

A number of elements in those Nokogiri classes are available on the Kitchen classes.

### `Document` methods of note

### `clipboard`

A document gives you access to named clipboards.  Clipboards are places where you can store lists of things.  For example, as you iterate through elements in a document you may `cut` them to a clipboard and then `paste` them out later.

```ruby
doc.clipboard.paste
```

Pastes the contents of the clipboard named `:default`.  You could on the other hand cut to and paste from a clipboard with a different name:

```ruby
doc.clipboard(name: :exercises).paste
```

### `pantry`

A document also gives you access to named pantries.  A pantry is a place to store items that you can label.

```ruby
doc.pantry.store "some text", label: "some label"
doc.pantry.get("some label") # => "some text"
```

The above uses the `:default` pantry.  You can also use named pantries:

```ruby
doc.pantry(name: :figure_titles).store "Moon landing", label: "id42"
```

### `counter`

Oftentimes we need to count things in a document.  A document provides named counters.

```ruby
doc.counter(:chapter).increment
doc.counter(:chapter).get
doc.counter(:chapter).reset
```

### `Element` methods of note

#### `cut` & `copy`

You can `cut` and `copy` elements directly to a clipboard:

```ruby
doc.each("div.example") do |div|
  div.cut to: :my_special_clipboard
end

doc.first("p").copy to: :foo
```

#### `trash`

Delete an element

```ruby
element.first("h3").trash
```

#### `prepend`, `append`

Prepend or append children or siblings:

```ruby
my_element.prepend child: "<br/>"
my_element.prepend sibling: "<div></div>"
my_element.append child: "<br/>"
my_element.append sibling: "<p/>"
```

#### `replace_children`

Or replace all the children:

```ruby
my_element.replace_children with: "<div></div>"
```

#### `contains?`

See if an element contains an element matching a selector:

```ruby
my_element.contains?(".title") #=> true or false
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

## Recipe Development

Kitchen tries to give helpful error messages instead of huge stack traces, e.g.:

```
The recipe has an error: undefined method `each' for main:Object
at or near the following highlighted line

-----+ ./tutorial/03.rb -----
   17|
   18|   doc.each("div[data-type='chapter']") do |chapter|
   19|     each("div.review-questions") do |elem|
   20|       elem.first("h3").trash
   21|       elem.cut to: :review_questions

`each` needs to be called on a document or element object

Encountered on line 64 in the input document on element:
<div data-type="chapter">...</div>

```

## Gem Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

Documentation is handled via YARD.  The [Solargraph gem](https://solargraph.org/guides/getting-started) can be used in popular editors for code completion.


### Specs

* TODO: talk about match_html_nodes vs match_html_strict

### VSCode

1. Visit `vscode:extension/ms-vscode-remote.remote-containers` in a browser
2. It'll open VSCode and bring you to an extension install screen, click "Install"
3. Click the remote button now in the bottom left hand corner.
4. Click "Remote-Containers: Open Folder in Container"
5. Select the cloned kitchen folder.

This (assuming you have Docker installed) will launch a docker container for Kitchen, install Ruby and needed libraries, and then let you edit the code running in that container through VSCode.  Solargraph will work (code completion and inline documentation).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/openstax/kitchen. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/openstax/kitchen/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## TODO

* https://github.com/tmuxinator/tmuxinator
* nokogiri-diff
* In debugger, update the diff on each step, if nothing changed, keep diff target from what did last change
* rubocop (and see if it will help catch bad parens, missing parts of do..end etc)
* Travis
* document with Yard and then access documentation when printing errors (https://stackoverflow.com/a/25947541)
* Think up and handle a bunch more recipe errors, test they all raise some kind of `RecipeError`.
* https://marketplace.visualstudio.com/items?itemName=castwide.solargraph
* https://github.com/castwide/solargraph/issues/211
* https://github.com/castwide/vscode-solargraph/issues/7
* https://solargraph.org/guides/yard
* https://code.visualstudio.com/docs/remote/containers
* https://stelligent.com/2020/04/10/development-acceleration-through-vs-code-remote-containers-setting-up-a-foundational-configuration/
* https://code.visualstudio.com/docs/remote/containers#_attaching-to-running-containers
* https://code.visualstudio.com/docs/remote/containers#_attached-container-config-reference

## Code of Conduct

Everyone interacting in the Kitchen project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/openstax/kitchen/blob/master/CODE_OF_CONDUCT.md).
