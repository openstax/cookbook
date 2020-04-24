#!/usr/bin/env ruby

require "bundler/setup"
require "byebug"
require "kitchen"

recipe_03 = Kitchen::Recipe.new do |doc|

  # Querying is namespace aware, so a CSS selector for the metadata div is not
  # sufficient and errors out:
  #
  # first!("div[data-type='metadata']") { copy to: :metadata }
  #
  # Use this xpath selector instead:
  doc.first!("//ns:div[@data-type='metadata']",
             ns: "http://www.w3.org/1999/xhtml").copy to: :metadata

  doc.each("div[data-type='chapter']") do |chapter|
    chapter.each("div.review-questions") do |elem|
      elem.first("h3").trash
      elem.cut to: :review_questions
    end
    chapter.each("div.critical-thinking") do |elem|
      elem.first("h3").trash
      elem.cut to: :critical_thinking
    end

    chapter.append child: <<~HTML
      <div class="eoc">
        #{ doc.create_element(chapter.sub_header_name,
                              "End of Chapter Stuff",
                              "data-type" => 'document-title') }
        <div class="critical-thinking-container">
          #{doc.clipboard(name: :critical_thinking).paste}
        </div>
        <div class="review-questions-container">
          #{doc.clipboard(name: :review_questions).paste}
        </div>
        #{doc.clipboard(name: :metadata).paste}
      </div>
    HTML
  end

end

Kitchen::Oven.bake(
  input_file: File.expand_path("03-passes-raw.html", __dir__),
  recipes: recipe_03,
  output_file: File.expand_path("outputs/03-passes-baked.html", __dir__)
)
