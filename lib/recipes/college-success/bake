#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../college-success/collegesuccess_recipe'

hs_delete = Kitchen::BookRecipe.new(book_short_name: :hs_delete) do |doc|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  book.search('div.real-deal').each(&:trash)
  book.search('div.student-story').each(&:trash)
  book.search('section.family-friends').each(&:trash)
  book.search('section.checking-in').each(&:trash)

  book.chapters.each do |chapter|
    eoc_sections = %w[summary career-connection rethinking where-go]
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
  recipes: [hs_delete, COLLEGESUCCESS_RECIPE, VALIDATE_OUTPUT],
  output_file: opts[:output],
  resource_dir: opts[:resources] || nil
)
