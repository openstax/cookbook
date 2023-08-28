# frozen_string_literal: true

ANATOMY_RECIPE = Kitchen::BookRecipe.new(book_short_name: :anatomy) do |doc, resources|
  include Kitchen::Directions

  # Set overrides
  doc.selectors.override(
    reference: 'section.references'
  )

  book = doc.book
  metadata = book.metadata

  # Some stuff just goes away
  book.search('cnx-pi').trash

  BakeImages.v1(book: book, resources: resources)
  BakeUnnumberedFigure.v1(book: book)
  BakePreface.v1(book: book, title_element: 'h1')
  BakeUnitTitle.v1(book: book)
  AddInjectedExerciseId.v1(book: book)
  BakeChapterIntroductions.v2(
    book: book,
    options: {
      bake_chapter_outline: false,
      introduction_order: :v2
    }
  )
  BakeChapterTitle.v1(book: book)

  book.notes('$.homeostatic').each { |note| note['use-subtitle'] = true }

  BakeAutotitledNotes.v1(
    book: book,
    classes: %w[interactive everyday homeostatic disorders career aging diseases]
  )

  book.chapters.each do |chapter|
    BakeLearningObjectives.v1(chapter: chapter)
    BakeNonIntroductionPages.v1(chapter: chapter)
    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata)
    BakeChapterSummary.v1(chapter: chapter, metadata_source: metadata)

    exercise_section_classes = %w[interactive-exercise multiple-choice free-response]

    exercise_section_classes.each do |klass|
      MoveExercisesToEOC.v1(
        chapter: chapter,
        metadata_source: metadata,
        klass: klass
      )
    end

    BakeAllNumberedExerciseTypes.v1(
      within: chapter.search('div.os-eoc'),
      exercise_options: { suppress_solution_if: true }
    )

    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}")
    end

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}")
    end
  end

  book.pages('$.appendix').each do |page|
    appendix_letter = [*('A'..'Z')][page.count_in(:book) - 1]

    page.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure, number: "#{appendix_letter}#{figure.count_in(:page)}")
    end

    page.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table, number: "#{appendix_letter}#{table.count_in(:page)}")
    end

    BakeAppendix.v1(page: page, number: appendix_letter)
  end

  BakeReferences.v3(book: book, metadata_source: metadata)
  BakeEquations.v1(book: book)
  BakeMathInParagraph.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeLinks.v1(book: book)
end
