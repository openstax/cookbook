#!/usr/bin/env ruby

require "bundler/setup"
require "byebug"
require "kitchen"

recipe_01 = Kitchen::Recipe.new do

  each("div[data-type=chapter]") do
    each("div.will-move") do
      set_name "section"
      cut
    end

    append_child child: <<~HTML
      <div class='eoc'>
        <div class='os-title'>End of Chapter Collations</div>
        #{paste}
      </div>
    HTML
  end

end

Kitchen::Oven.bake(
  input_file: File.expand_path("01-moveto-raw.html", __dir__),
  recipes: recipe_01,
  output_file: File.expand_path("01-moveto-baked.html", __dir__)
)
