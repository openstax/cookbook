#!/usr/bin/env ruby

require "bundler/setup"
require "byebug"
require "kitchen"

# Skipping stuff from previous tutorials, also skipped moving practice b/c that is
# not numbering

recipe_04 = Kitchen::Recipe.new do |doc|

  doc.each("div[data-type='chapter']") do |chapter|
    doc.counter(:chapter).inc
    doc.counter(:page).reset

    chapter.first!("h1[data-type='document-title']").prepend child: <<~HTML
      <span class="os-number">#{doc.counter(:chapter).get}</span>
    HTML

    chapter.each("div[data-type='page']") do |page|
      doc.counter(:page).inc

      page.first!("h2[data-type='document-title']").prepend child: <<~HTML
        <span class="os-number">#{doc.counter(:chapter).get}.#{doc.counter(:page).get}</span>
      HTML
    end
  end

  doc.each(".exercise") do |exercise|
    doc.counter(:exercise).inc

    exercise.prepend child: <<~HTML
      <span class="os-number">#{doc.counter(:exercise).get}</span>
    HTML

    exercise.first(".solution")
            &.cut(to: :solutions)
            &.prepend child: <<~HTML
              <span class="os-number">#{doc.counter(:exercise).get}</span>
            HTML
  end

  doc.first!("body").append child: <<~HTML
    <div class="eob">
      <h1>End of Book Solutions</h1>
      #{doc.clipboard(name: :solutions).paste}
    </div>
  HTML

end

Kitchen::Oven.bake(
  input_file: File.expand_path("04-numbering-raw.html", __dir__),
  recipes: recipe_04,
  output_file: File.expand_path("outputs/04-numbering-baked.html", __dir__)
)
