#!/usr/bin/env ruby

require "bundler/setup"
require "byebug"
require "kitchen"

recipe_01 = Kitchen::Recipe.new do |doc|

  doc.each("div[data-type=chapter]") do |elem|
    doc.counter(:chapter).inc
    elem.each("div.will-move") do |elem|
      elem.name = "section"
      elem.cut
    end

    elem.append child: <<~HTML
      <div class='eoc'>
        <div class='os-title'>End of Chapter Collations</div>
        #{doc.clipboard.paste}
      </div>
    HTML
  end

end

Kitchen::Oven.bake(
  input_file: File.expand_path("01-moveto-raw.html", __dir__),
  recipes: recipe_01,
  output_file: File.expand_path("outputs/01-moveto-baked.html", __dir__)
)
