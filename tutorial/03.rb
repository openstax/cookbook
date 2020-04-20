#!/usr/bin/env ruby

require "bundler/setup"
require "byebug"
require "kitchen"

recipe_03 = Kitchen::Recipe.new do

  # Querying is namespace aware, so a CSS selector for the metadata div is not
  # sufficient and errors out:
  #
  # first!("div[data-type='metadata']") { copy to: :metadata }
  #
  # Use this xpath selector instead:
  first!("//ns:div[@data-type='metadata']", ns: "http://www.w3.org/1999/xhtml") do
    copy to: :metadata do
      # could do something here with the copy if desired
    end
  end

  each("div[data-type='chapter']") do
    each("div.review-questions") do
      first("h3") { trash }
      cut to: :review_questions
    end
    each("div.critical-thinking") do
      first("h3") { trash }
      cut to: :critical_thinking
    end

    append_child child: <<~HTML
      <div class="eoc">
        #{ sub_header(attributes: {data_type: 'document-title'},
                      content: "End of Chapter Stuff") }
        <div class="critical-thinking-container">
          #{paste(from: :critical_thinking)}
        </div>
        <div class="review-questions-container">
          #{paste(from: :review_questions)}
        </div>
        #{paste(from: :metadata)}
      </div>
    HTML
  end

end

Kitchen::Oven.bake(
  input_file: File.expand_path("03-passes-raw.html", __dir__),
  recipes: recipe_03,
  output_file: File.expand_path("03-passes-baked.html", __dir__)
)
