# frozen_string_literal: true

CHEMISTRY_RECIPE = Kitchen::BookRecipe.new(book_short_name: :chemistry) do |doc, resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  # Some stuff just goes away
  book.search('cnx-pi').trash

  BakeImages.v1(book: book, resources: resources)
  BakeUnnumberedFigure.v1(book: book)
  BakePreface.v1(book: book)

  answer_key = BookAnswerKeyContainer.v1(book: book, solutions_plural: false)
  book.chapters.each do |chapter|
    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata)
    BakeChapterKeyEquations.v1(chapter: chapter, metadata_source: metadata)
    BakeChapterSummary.v1(chapter: chapter, metadata_source: metadata)
    MoveExercisesToEOC.v3(chapter: chapter, metadata_source: metadata, klass: 'exercises')
    chapter.search('section.exercises').exercises.each do |exercise|
      BakeNumberedExercise.v1(exercise: exercise, number: exercise.count_in(:chapter))
    end

    answer_key_inner_container = AnswerKeyInnerContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      append_to: answer_key,
      options: { solutions_plural: false }
    )

    DefaultStrategyForAnswerKeySolutions.v1(
      strategy_options: { selectors: ['section.exercises'] },
      chapter: chapter,
      append_to: answer_key_inner_container
    )
  end

  BakeChapterIntroductions.v1(book: book)
  BakeChapterTitle.v1(book: book)

  book.chapters.each do |chapter|
    BakeLearningObjectives.v1(chapter: chapter)
    BakeNonIntroductionPages.v1(chapter: chapter)

    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}")
    end

    chapter.examples.each do |example|
      BakeExample.v1(example: example,
                     number: "#{chapter.count_in(:book)}.#{example.count_in(:chapter)}",
                     title_tag: 'h3')
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

    page.examples.each do |example|
      BakeExample.v1(example: example,
                     number: "#{appendix_letter}#{example.count_in(:page)}",
                     title_tag: 'div')
    end

    BakeAppendix.v1(page: page, number: appendix_letter)
  end

  BakeUnnumberedTables.v1(book: book)

  book.search('div[data-type="solution"]').each do |solution|
    BakeFirstElements.v1(within: solution)
  end

  note_classes = %w[link-to-learning everyday-life chemist-portrait sciences-interconnect]
  BakeAutotitledNotes.v1(book: book, classes: note_classes)
  BakeUnclassifiedNotes.v1(book: book)
  BakeStepwise.v1(book: book)
  BakeMathInParagraph.v1(book: book)
  BakeEquations.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeLinks.v1(book: book)
end
