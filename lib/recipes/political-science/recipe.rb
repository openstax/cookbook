# frozen_string_literal: true

POLITICAL_SCIENCE_RECIPE = Kitchen::BookRecipe.new(book_short_name: :political_science) \
do |doc, resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  BakeImages.v1(book: book, resources: resources)
  BakeUnnumberedFigure.v1(book: book)
  BakePreface.v1(book: book)
  BakeChapterIntroductions.v1(book: book)
  BakeChapterTitle.v1(book: book)
  BakeUnitTitle.v1(book: book)
  book.chapters.each do |chapter|
    BakeLearningObjectives.v1(chapter: chapter)
    BakeNonIntroductionPages.v1(chapter: chapter)
    # Eoc sections
    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      container_key: 'summary',
      uuid_key: '.summary',
      section_selector: 'section.summary'
    ) do |section|
      RemoveSectionTitle.v1(section: section)
      title = EocSectionTitleLinkSnippet.v1(page: section.ancestor(:page))
      section.prepend(child: title)
    end

    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata)

    chapter.pages.search('section.review-questions').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(question: question, number: question.count_in(:chapter))
    end

    eoc_sections = %w[review-questions suggested-readings]
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

    # Tables and figures
    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}")
    end
    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}")
    end
  end

  # Bake the notes
  autotitled_classes = %w[show-data connecting-courses meet-professional changing-political what-do
                          where-engage media-video media-podcast]
  BakeAutotitledNotes.v1(book: book, classes: autotitled_classes)

  BakeFootnotes.v1(book: book)
  BakeIframes.v1(book: book)

  # Eob sections
  BakeReferences.v1(book: book, metadata_source: metadata, numbered_title: true)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeLinks.v1(book: book)
end
