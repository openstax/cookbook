#!/usr/bin/env ruby

require "bundler/setup"
require "byebug"
require "kitchen"

recipe_02 = Kitchen::Recipe.new do

  each("div[data-type='chapter']") do
    each("div.review-questions") do
      cut to: :review_questions
    end
    each("div.critical-thinking") do
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
      </div>
    HTML
  end

end

Kitchen::Oven.bake(
  input_file: File.expand_path("02-create-content-raw.html", __dir__),
  recipes: recipe_02,
  output_file: File.expand_path("outputs/02-create-content-baked.html", __dir__)
)
