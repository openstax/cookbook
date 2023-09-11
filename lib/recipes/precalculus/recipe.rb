#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../precalculus/precalculus_recipe'

coreq_delete = Kitchen::BookRecipe.new(book_short_name: :coreq_delete) do |doc, _resources|
  include Kitchen::Directions

  book = doc.book

  book.search('section.practice-perfect').each(&:trash)
  book.search('section.coreq-skills').each(&:trash)
end

opts = Slop.parse do |slop|
  slop.string '--input', 'Assembled XHTML input file', required: true
  slop.string '--output', 'Baked XHTML output file', required: true
  slop.string '--resources', 'Path to book resources directory', required: false
end

puts Kitchen::Oven.bake(
  input_file: opts[:input],
  recipes: [coreq_delete, PRECALCULUS_RECIPE, VALIDATE_OUTPUT],
  output_file: opts[:output],
  resource_dir: opts[:resources] || nil
)
