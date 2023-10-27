# frozen_string_literal: true

SOCIOLOGY_RECIPE = Kitchen::BookRecipe.new(book_short_name: :sociology) do |doc, _resources|
  include Kitchen::Directions

  # Set overrides
  doc.selectors.override(
    page_summary: 'section.section-summary',
    reference: 'section.references'
  )

  book = doc.book
  metadata = book.metadata
  edition_symbol = book.first('head').first('title').text.match(/(\d)e$/).to_s
  # Some stuff just goes away
  book.search('cnx-pi').trash

  # Remove data-type="description" from body metadata placed in Sociology 2e
  if edition_symbol == '2e'
    book.body.search('div[data-type="metadata"] > div[data-type="description"]').trash
  end

  BakeUnnumberedFigure.v1(book: book)
  BakePreface.v1(book: book)

  # Bake NumberedTable in Preface
  book.pages('$.preface').tables('$:not(.unnumbered)').each do |table|
    BakeNumberedTable.v1(table: table, number: table.count_in(:page))
  end

  BakeChapterTitle.v1(book: book)
  BakeChapterIntroductions.v1(book: book)

  # Bake EoC sections
  book.chapters.each do |chapter|
    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata)
    BakeChapterSummary.v1(chapter: chapter, metadata_source: metadata, klass: 'section-summary')
    MoveExercisesToEOC.v3(chapter: chapter, metadata_source: metadata, klass: 'section-quiz')
    MoveExercisesToEOC.v3(chapter: chapter, metadata_source: metadata, klass: 'short-answer')
    BakeFurtherResearch.v1(chapter: chapter, metadata_source: metadata)
    chapter.composite_pages.each do |composite_page|
      composite_page.search('section.short-answer, section.section-quiz').exercises.each \
      do |exercise|
        BakeNumberedExercise.v1(
          exercise: exercise, number: exercise.count_in(:composite_page),
          options: { suppress_solution_if: :even?, note_suppressed_solutions: true }
        )
      end
    end
    BakeChapterReferences.v1(chapter: chapter, metadata_source: metadata)
  end

  # Bake Answer Key
  if edition_symbol == '3e'
    solution_container = BookAnswerKeyContainer.v1(book: book, solutions_plural: false)
    book.chapters.each do |chapter|
      inner_container = AnswerKeyInnerContainer.v1(
        chapter: chapter, metadata_source: metadata, append_to: solution_container,
        options: { solutions_plural: false }
      )
      DefaultStrategyForAnswerKeySolutions.v1(
        strategy_options: { selectors: %w[section-quiz].prefix('section.') },
        chapter: chapter, append_to: inner_container
      )
    end
  end

  book.chapters.each do |chapter|
    BakeLearningObjectives.v1(chapter: chapter)

    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}")
    end

    BakeNonIntroductionPages.v1(chapter: chapter)

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}")

    end
  end

  BakeAutotitledNotes.v1(book: book, classes: %w[sociological-research
                                                 sociology-real-world
                                                 sociology-big-picture
                                                 sociology-policy-debate])
  BakeStepwise.v1(book: book)
  BakeUnnumberedTables.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeToc.v1(book: book)
  BakeFolio.v1(book: book)
  BakeLinks.v1(book: book)
end
