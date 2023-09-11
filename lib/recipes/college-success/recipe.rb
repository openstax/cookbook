# frozen_string_literal: true

COLLEGE_SUCCESS_HS_DELETE_RECIPE = Kitchen::BookRecipe.new(book_short_name: :hs_delete) do |doc|
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
