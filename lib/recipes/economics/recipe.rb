# frozen_string_literal: true

ECONOMICS_RECIPE = Kitchen::BookRecipe.new(book_short_name: :economics) do |doc, _resources|
  include Kitchen::Directions

  doc.selectors.override(
    reference: 'section.references'
  )

  book = doc.book
  metadata = book.metadata

  # Some stuff just goes away
  book.search('cnx-pi').trash

  BakeUnnumberedFigure.v1(book: book)
  BakePreface.v1(book: book, title_element: 'h1')
  BakeChapterIntroductions.v2(book: book)
  BakeChapterTitle.v1(book: book)
  BakeUnclassifiedNotes.v1(book: book)
  BakeIframes.v1(book: book)
  BakeAutotitledNotes.v1(book: book, classes: %w[linkup bringhome clearup workout])
  answer_key = BookAnswerKeyContainer.v1(book: book)

  book.chapters.each do |chapter|
    BakeLearningObjectives.v1(chapter: chapter)
    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata)
    BakeChapterSummary.v1(chapter: chapter, metadata_source: metadata)

    exercise_section_classes = \
      %w[summary self-check-questions review-questions critical-thinking problems]

    chapter.search(exercise_section_classes.prefix('section.')).exercises.each do |exercise|
      BakeNumberedExercise.v1(exercise: exercise, number: exercise.count_in(:chapter))
    end

    exercise_section_classes.each do |klass|
      MoveExercisesToEOC.v1(chapter: chapter, metadata_source: metadata, klass: klass)
    end

    answer_key_inner_container = AnswerKeyInnerContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      append_to: answer_key
    )

    DefaultStrategyForAnswerKeySolutions.v1(
      strategy_options: {
        selectors: %w[self-check-questions problems ap-test-prep].prefix('section.')
      },
      chapter: chapter,
      append_to: answer_key_inner_container
    )

    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}")
    end

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}")
    end

    chapter.exercises.each do |exercise|
      BakeFirstElements.v1(within: exercise)
    end

    BakeNonIntroductionPages.v1(chapter: chapter)
  end
  book.pages('$.appendix').each do |page|
    appendix_letter = [*('A'..'Z')][page.count_in(:book) - 1]

    BakeAppendix.v1(page: page, number: appendix_letter)
    page.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{appendix_letter}#{figure.count_in(:page)}")
    end

    page.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{appendix_letter}#{table.count_in(:page)}")
    end

    page.search('section').exercises.each do |exercise|
      BakeNumberedExercise.v1(exercise: exercise,
                              number: "#{appendix_letter}#{exercise.count_in(:page)}")
      BakeFirstElements.v1(within: exercise)
    end
  end

  BakeUnnumberedTables.v1(book: book)

  book.search('div.os-solutions-container').solutions.each do |solution|
    BakeFirstElements.v1(within: solution)
  end

  BakeReferences.v2(book: book, metadata_source: metadata)
  BakeEquations.v1(book: book)
  BakeMathInParagraph.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeRexWrappers.v1(book: book)
  BakeLinks.v1(book: book)
end
