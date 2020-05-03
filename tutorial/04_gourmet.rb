#!/usr/bin/env ruby

require "bundler/setup"
require "byebug"
require "kitchen"

# Skipping stuff from previous tutorials, also skipped moving practice b/c that is
# not numbering

recipe_04 = Kitchen::Recipe.new do |doc|

  # We encode more knowledge about the books in a `BookDocument` over the basic
  # `Document`.  Gives us methods like `each_chapter` that knows the CSS selector
  # for a book chapter.

  book = Kitchen::BookDocument.new(document: doc, numbering_style: "1.1")

  # Here we replace a bunch of common code with `each_chapter`, `each_page`, and
  # `number_it` methods.  Here's the original code:
  #
  #   doc.each("div[data-type='chapter']") do |chapter|
  #     doc.counter(:chapter).inc
  #     doc.counter(:page).reset
  #
  #     chapter.first!("h1[data-type='document-title']").prepend child: <<~HTML
  #       <span class="os-number">#{doc.counter(:chapter).get}</span>
  #     HTML
  #
  #     chapter.each("div[data-type='page']") do |page|
  #       doc.counter(:page).inc
  #
  #       page.first!("h2[data-type='document-title']").prepend child: <<~HTML
  #         <span class="os-number">#{doc.counter(:chapter).get}.#{doc.counter(:page).get}</span>
  #       HTML
  #     end
  #   end
  #
  # And here's the simplification:

  book.each_chapter do |chapter|
    chapter.number_it
    chapter.each_page(&:number_it)
  end

  # Similar to the above, we could rewrite the next bit of code as:
  #
  #   book.each_exercise do |exercise|
  #     exercise.number_it
  #     exercise.solution.cut(to: :solutions).number_it
  #   end

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

  # And again we could add an abstraction for other pages like end of book
  # solutions, tho need some help on how to best do this.
  #
  #   book.add_section(
  #     classes: %w(eob),
  #     title: "End of Book Solutions",
  #     content: <<~HTML
  #       #{book.clipboard(name: :solutions).paste}
  #     HTML
  #   )

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
  output_file: File.expand_path("outputs/04-numbering-baked-gourmet.html", __dir__)
)
