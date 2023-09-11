# frozen_string_literal: true

AMERICAN_GOVERNMENT_RECIPE = Kitchen::BookRecipe.new(book_short_name: :american_gov) \
do |doc, resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  # Some stuff just goes away
  book.search('cnx-pi').trash

  BakeImages.v1(book: book, resources: resources)
  BakePreface.v1(book: book)
  BakeUnitTitle.v1(book: book)
  BakeChapterTitle.v1(book: book)
  BakeChapterIntroductions.v2(
    book: book,
    options: {
      strategy: :add_objectives,
      bake_chapter_outline: true,
      introduction_order: :v2
    }
  )
  BakeUnclassifiedNotes.v1(book: book)
  BakeUnnumberedFigure.v1(book: book)

  answer_key = BookAnswerKeyContainer.v1(book: book)

  book.chapters.each do |chapter|
    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata)
    BakeChapterSummary.v1(chapter: chapter, metadata_source: metadata)
    BakeNonIntroductionPages.v1(chapter: chapter)

    exercise_section_classes = %w[review-questions critical-thinking]

    chapter.search(exercise_section_classes.prefix('section.')).exercises.each do |exercise|
      BakeNumberedExercise.v1(exercise: exercise, number: exercise.count_in(:chapter))
    end

    exercise_section_classes.each do |klass|
      MoveExercisesToEOC.v1(chapter: chapter, metadata_source: metadata, klass: klass)
    end

    answer_key_inner_container = AnswerKeyInnerContainer.v1(
      chapter: chapter, metadata_source: metadata, append_to: answer_key
    )

    DefaultStrategyForAnswerKeySolutions.v1(
      strategy_options: { selectors: ['section.review-questions'] },
      chapter: chapter,
      append_to: answer_key_inner_container
    )

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(
        figure: figure,
        number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}"
      )
    end

    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(
        table: table,
        number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}"
      )
    end
  end

  book.pages('$.appendix').each do |page|
    appendix_letter = [*('A'..'Z')][page.count_in(:book) - 1]

    page.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure, number: "#{appendix_letter}#{figure.count_in(:page)}")
    end

    page.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(
        table: table,
        number: "#{appendix_letter}#{table.count_in(:page)}"
      )
    end

    page.examples.each do |example|
      BakeExample.v1(
        example: example,
        number: "#{appendix_letter}#{example.count_in(:page)}",
        title_tag: 'div'
      )
    end

    BakeAppendix.v1(page: page, number: appendix_letter)
  end

  BakeAutotitledNotes.v1(
    book: book,
    classes: %w[link-to-learning
                middle-ground
                milestone
                get-connected
                insider-perspective]
  )

  BakeScreenreaderSpans.v1(book: book)
  BakeSuggestedReading.v1(book: book)
  BakeReferences.v1(book: book, metadata_source: metadata)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinks.v1(book: book)
end
