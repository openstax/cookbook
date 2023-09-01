# frozen_string_literal: true

MICROBIOLOGY_RECIPE = Kitchen::BookRecipe.new(book_short_name: :microbiology) do |doc, resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  # Some stuff just goes away
  book.search('cnx-pi').trash

  BakeImages.v1(book: book, resources: resources)
  BakeUnnumberedFigure.v1(book: book)
  BakePreface.v1(book: book, title_element: 'h1')
  BakeChapterIntroductions.v1(book: book)
  BakeChapterTitle.v1(book: book)

  BakeAutotitledNotes.v1(
    book: book,
    classes: %w[clinical-focus check-your-understanding micro-connection
                link-to-learning eye-on-ethics case-in-point disease-profile]
  )

  book_answer_key = BookAnswerKeyContainer.v1(book: book, solutions_plural: false)
  book.chapters.each do |chapter|
    BakeLearningObjectives.v1(chapter: chapter)
    BakeNonIntroductionPages.v1(chapter: chapter)
    BakeChapterSummary.v1(chapter: chapter, metadata_source: metadata)

    eoc_wrapper = ChapterReviewContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      klass: 'review-questions'
    )

    exercise_section_classes = %w[multiple-choice true-false matching
                                  fill-in-the-blank short-answer critical-thinking]

    exercise_section_classes.each do |klass|
      MoveExercisesToEOC.v1(
        chapter: chapter,
        metadata_source: metadata,
        append_to: eoc_wrapper,
        klass: klass
      )
    end

    chapter.search(exercise_section_classes.prefix('section.').join(', ')).exercises
           .each do |exercise|
      BakeNumberedExercise.v1(exercise: exercise, number: exercise.count_in(:chapter))
    end

    # Bake answer key from chapter/ move solutions from eoc into answer key
    inner_container = AnswerKeyInnerContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      append_to: book_answer_key,
      options: { solutions_plural: false }
    )
    DefaultStrategyForAnswerKeySolutions.v1(
      strategy_options: { selectors: exercise_section_classes.prefix('section.') },
      chapter: chapter, append_to: inner_container
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

  BakeUnnumberedTables.v1(book: book)
  BakeEquations.v1(book: book)
  BakeMathInParagraph.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeLinks.v1(book: book)
end
