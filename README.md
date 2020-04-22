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

recipe = Kitchen::Recipe.new do
  each("div.section") do
    set_name "section"
  end
end

Kitchen::Oven.bake(
  input_file: "some_file.xhtml",
  recipes: recipe,
  output_file: "some_other_file.xhtml"
)
```

The above example changes all `<div class="section">` tags to `<section class="section">`.

Inside the `do ... end` block passed to the `Recipe` you have a number of methods available for modifying the content:

#### `each`

`each` iterates over elements matching the provided CSS selector or xpath argument, and executes the block passed to it on that element.  Other iterators with their own selectors can be nested in that block and their results will be limited to the elements inside the elements found above them.

```ruby
each("div.example") do # find all "div.example" elements
  add_class("foo")     # add a class to each of those elements
  each("p") do         # find all "p" elements inside "div.example" elements
    set_name "div"     # change them to "div" tags
  end
end
```

#### `first`

`first` is like `each` except it only works on the first element found with the provided selector, not on all elements found.

`first!` is the same as `first` except it errors if no matching element is found.

## One-file scripts

Want to make a one-file script to do some baking?  Use the "inline" form of bundler:

```ruby
#!/usr/bin/env ruby

require "bundler/inline"

gemfile do
  gem 'kitchen', git: 'https://github.com/openstax/kitchen.git', ref: 'some_sha_here'
end

require "kitchen"

recipe = Kitchen::Recipe.new do
  # ... recipe steps here
end

Kitchen::Oven.bake(
  input_file: "some_file.xhtml",
  recipes: recipe,
  output_file: "some_other_file.xhtml")
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

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

## Code of Conduct

Everyone interacting in the Kitchen project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/openstax/kitchen/blob/master/CODE_OF_CONDUCT.md).
