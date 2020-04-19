#!/usr/bin/env ruby

require "bundler/setup"
require "byebug"
require "kitchen"

recipe_02 = Kitchen::Recipe.new do

  each("div[data-type='chapter']") do
    each("div.review-questions") do
      first("h3").remove
      cut to: :review_questions
    end
    each("div.critical-thinking") do
      first("h3").remove
      cut to: :critical_thinking
    end

    append_child <<~HTML
      <div class="eoc">
        #{
          container(name: first("h*").next_lower_header, data_type: 'document-title') do
            End of Chapter Stuff
          end
        }
        <div class="critical-thinking-container">
          #{paste(:critical_thinking)}
        </div>
        <div class="review-questions-container">
          #{paste(review_questions)}
        </div>
      </div>
    HTML
  end

end

Kitchen::Oven.bake(
  input_file: File.expand_path("02-create-content-raw.html", __dir__),
  recipes: recipe_02,
  output_file: File.expand_path("02-create-content-baked.html", __dir__)
)
