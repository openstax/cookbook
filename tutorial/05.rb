#!/usr/bin/env ruby

require "bundler/setup"
require "byebug"
require "kitchen"

recipe_05 = Kitchen::Recipe.new do |doc|

  doc.each("table") do |table|
    doc.counter(:table).inc
    caption = "Table #{doc.counter(:table).get}"

    table.prepend child: <<~HTML
      <caption>#{caption}</caption>
    HTML

    doc.pantry.store caption, label: table["id"]
  end

  doc.each("figure") do |figure|
    doc.counter(:figure).inc
    caption = "Figure #{doc.counter(:figure).get}"

    figure.prepend child: <<~HTML
      <caption>#{caption}</caption>
    HTML

    doc.pantry.store caption, label: figure["id"]
  end

  doc.each("a.needs-label") do |anchor|
    anchor.replace_children with: doc.pantry.get(anchor["href"][1..-1])
  end

end

Kitchen::Oven.bake(
  input_file: File.expand_path("05-target-label.html", __dir__),
  recipes: recipe_05,
  output_file: File.expand_path("outputs/05-target-label-baked.html", __dir__)
)
