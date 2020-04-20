#!/usr/bin/env ruby

require "bundler/setup"
require "byebug"
require "kitchen"

# Skipping stuff from previous tutorials, also skipped moving practice b/c that is
# not numbering

recipe_04 = Kitchen::Recipe.new do

  each("div[data-type='chapter']") do
    count :chapter
    reset_count :page

    first!("h1[data-type='document-title']") do
      prepend_child child: <<~HTML
        <span class="os-number">#{get_count(:chapter)}</span>
      HTML
    end

    each("div[data-type='page']") do
      count :page

      first!("h2[data-type='document-title']") do
        prepend_child child: <<~HTML
          <span class="os-number">#{get_count(:chapter)}.#{get_count(:page)}</span>
        HTML
      end
    end
  end

  each(".exercise") do
    count :exercise

    prepend_child child: <<~HTML
      <span class="os-number">#{get_count(:exercise)}</span>
    HTML

    first(".solution") do
      prepend_child child: <<~HTML
        <span class="os-number">#{get_count(:exercise)}</span>
      HTML

      cut to: :solutions
    end
  end

  first!("body") do
    append_child child: <<~HTML
      <div class="eob">
        <h1>End of Book Solutions</h1>
        #{paste(from: :solutions)}
      </div>
    HTML
  end

end

Kitchen::Oven.bake(
  input_file: File.expand_path("04-numbering-raw.html", __dir__),
  recipes: recipe_04,
  output_file: File.expand_path("04-numbering-baked.html", __dir__)
)
