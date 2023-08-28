#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../recipes_helper'

# Hardcode locale = 'en' because CNX books contain other languages (vi, af, ru, de, ...) and no text is injected when baking them.
module Kitchen
  # Monkeypatched
  class Document
    def locale
      'en'
    end
  end
end

recipe = Kitchen::BookRecipe.new(book_short_name: :dummy) do |doc, resources|
  include Kitchen::Directions

  book = doc.book
  book.search('div.test123').each { |div| div.replace_children(with: 'Hello, world!') }

  BakeImages.v1(book: book, resources: resources)
end

opts = Slop.parse do |slop|
  slop.string '--input', 'Assembled XHTML input file', required: true
  slop.string '--output', 'Baked XHTML output file', required: true
  slop.string '--resources', 'Path to book resources directory', required: false
end

puts Kitchen::Oven.bake(
  input_file: opts[:input],
  recipes: recipe,
  output_file: opts[:output],
  resource_dir: opts[:resources] || nil
)
