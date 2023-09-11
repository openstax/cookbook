# frozen_string_literal: true

COLLEGE_SUCCESS_HIGH_SCHOOL_RECIPE = Kitchen::BookRecipe.new(book_short_name: :hs_college_success) \
do |doc|
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
