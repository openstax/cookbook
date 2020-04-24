#!/usr/bin/env ruby

require "bundler/setup"
require "byebug"
require "kitchen"

recipe_02 = Kitchen::Recipe.new do |doc|

  doc.each("div[data-type='chapter']") do |elem|
    elem.each("div.review-questions")  {|rq| rq.cut to: :review_questions  }
    elem.each("div.critical-thinking") {|ct| ct.cut to: :critical_thinking }

    elem.append child: <<~HTML
      <div class="eoc">
        #{ doc.create_element(elem.sub_header_name,
                              "End of Chapter Stuff",
                              "data-type" => 'document-title') }
        <div class="critical-thinking-container">
          #{doc.clipboard(name: :critical_thinking).paste}
        </div>
        <div class="review-questions-container">
          #{doc.clipboard(name: :review_questions).paste}
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
