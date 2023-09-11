# frozen_string_literal: true

ANTHROPOLOGY_RECIPE = Kitchen::BookRecipe.new(book_short_name: :anthropology) do |doc, resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  BakeImages.v1(book: book, resources: resources)
  BakeUnnumberedFigure.v1(book: book)
  BakePreface.v1(book: book)
  BakeChapterIntroductions.v1(book: book)
  BakeChapterTitle.v1(book: book)
  note_classes = %w[ethnographic-sketches fieldwork-activity profiles-anthropology media-podcast
                    media-video]
  BakeAutotitledNotes.v1(book: book, classes: note_classes)
  book.chapters.each do |chapter|
    BakeLearningObjectives.v1(chapter: chapter)
    BakeNonIntroductionPages.v1(chapter: chapter)

    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata)
    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      container_key: 'section-summary',
      uuid_key: '.section-summary',
      section_selector: 'section.section-summary'
    ) do |section|
      RemoveSectionTitle.v1(section: section)
    end
    exercise_selectors = 'section.critical-thinking'
    chapter.pages.search(exercise_selectors).injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(question: question, number: question.count_in(:chapter))
    end
    MoveExercisesToEOC.v1(chapter: chapter, metadata_source: metadata, klass: 'critical-thinking')
    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      container_key: 'references',
      uuid_key: '.references',
      section_selector: 'section.references'
    ) do |section|
      RemoveSectionTitle.v1(section: section)
    end

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}")
    end
    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}")
    end
  end

  BakeIframes.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeLinks.v1(book: book)
end
