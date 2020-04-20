#!/usr/bin/env ruby

require "bundler/setup"
require "byebug"
require "kitchen"

recipe_05 = Kitchen::Recipe.new do

  each("table") do
    count :table
    caption = "Table #{get_count(:table)}"

    prepend_child child: <<~HTML
      <caption>#{caption}</caption>
    HTML

    pantry.store caption, label: get_attribute("id")
  end

  each("figure") do
    count :figure
    caption = "Figure #{get_count(:figure)}"

    prepend_child child: <<~HTML
      <caption>#{caption}</caption>
    HTML

    pantry.store caption, label: get_attribute("id")
  end

  each("a.needs-label") do
    replace_children with: pantry.get(get_attribute("href")[1..-1])
  end

end

Kitchen::Oven.bake(
  input_file: File.expand_path("05-target-label.html", __dir__),
  recipes: recipe_05,
  output_file: File.expand_path("outputs/05-target-label-baked.html", __dir__)
)
