# frozen_string_literal: true

BIOLOGY_RECIPE = Kitchen::BookRecipe.new(book_short_name: :biology) do |doc, _resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  BakeUnnumberedFigure.v1(book: book)
  BakePreface.v1(book: book)
  BakeUnitTitle.v1(book: book)
  BakeChapterIntroductions.v1(book: book)
  BakeChapterTitle.v1(book: book)
  BakeAutotitledNotes.v1(book: book, classes: %w[visual-connection interactive evolution career
                                                 scientific everyday])
  book.chapters.each do |chapter|
    BakeLearningObjectives.v1(chapter: chapter)
    BakeNonIntroductionPages.v1(chapter: chapter)

    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata)
    BakeChapterSummary.v1(chapter: chapter, metadata_source: metadata, klass: 'summary')
    chapter.search('section.summary').each do |summary| # TODO: remove this
      summary.first('h3').remove_attribute('itemprop')
    end
    MoveExercisesToEOC.v1(chapter: chapter, metadata_source: metadata, klass: 'visual-exercise')
    MoveExercisesToEOC.v1(chapter: chapter, metadata_source: metadata, klass: 'multiple-choice')
    MoveExercisesToEOC.v1(chapter: chapter, metadata_source: metadata, klass: 'critical-thinking')
    exercise_selectors = \
      'section.visual-exercise, section.multiple-choice, section.critical-thinking'
    chapter.search(exercise_selectors).exercises.each do |exercise|
      BakeNumberedExercise.v1(exercise: exercise, number: exercise.count_in(:chapter),
                              options: { suppress_solution_if: true })
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

  BakeUnnumberedTables.v1(book: book)
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
  end

  BakeScreenreaderSpans.v1(book: book)
  BakeIframes.v1(book: book)
  BakeEquations.v1(book: book)
  BakeMathInParagraph.v1(book: book)
  BakeIndex.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeRexWrappers.v1(book: book)
  BakeLinks.v1(book: book)
end
