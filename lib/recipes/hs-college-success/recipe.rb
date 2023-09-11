#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../college-success/collegesuccess_recipe'

hs = Kitchen::BookRecipe.new(book_short_name: :hs_college_success) do |doc, _resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  BakeAutotitledNotes.v1(
    book: book,
    classes: %w[
      real-deal
      student-story
    ]
  )

  book.chapters.each do |chapter|
    eoc_sections = %w[family-friends summary checking-in]
    eoc_sections.each do |section_key|
      MoveCustomSectionToEocContainer.v1(
        chapter: chapter,
        metadata_source: metadata,
        container_key: section_key,
        uuid_key: ".#{section_key}",
        section_selector: "section.#{section_key}"
      ) do |section|
        RemoveSectionTitle.v1(section: section)
      end
    end
  end
end

opts = Slop.parse do |slop|
  slop.string '--input', 'Assembled XHTML input file', required: true
  slop.string '--output', 'Baked XHTML output file', required: true
  slop.string '--resources', 'Path to book resources directory', required: false
end

puts Kitchen::Oven.bake(
  input_file: opts[:input],
  recipes: [hs, COLLEGESUCCESS_RECIPE, VALIDATE_OUTPUT],
  output_file: opts[:output],
  resource_dir: opts[:resources] || nil
)
