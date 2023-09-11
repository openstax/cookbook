# frozen_string_literal: true

# Used in college success (bakes college-success and hs-college-success)
COLLEGE_SUCCESS_SHARED_RECIPE = Kitchen::BookRecipe.new(
  book_short_name: :college_success) do |doc, _resources|
  include Kitchen::Directions

  book = doc.book

  book.search('cnx-pi').trash

  BakeUnnumberedFigure.v1(book: book)
  BakePreface.v1(book: book)

  BakeChapterTitle.v1(book: book)
  BakeChapterIntroductions.v1(book: book)

  BakeAutotitledNotes.v1(
    book: book,
    classes: %w[
      student-profile
      activity
      analysis-question
      what-students-say
      application
      get-connected
    ]
  )

  book.chapters.each do |chapter|
    BakeNonIntroductionPages.v1(chapter: chapter)

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(
        figure: figure,
        number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}"
      )
    end
    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v2(
        table: table,
        number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}"
      )
    end
  end

  book.pages('$.appendix').each do |page|
    appendix_letter = [*('A'..'Z')][page.count_in(:book) - 1]
    BakeAppendix.v1(page: page, number: appendix_letter)

    page.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(
        figure: figure,
        number: "#{appendix_letter}#{figure.count_in(:page)}"
      )
    end
    page.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v2(
        table: table,
        number: "#{appendix_letter}#{table.count_in(:page)}"
      )
    end
  end

  # convert title tags
  book.sections('$[data-depth="3"]').each { |section| section.titles.first&.name = 'h5' }
  BakeUnnumberedTables.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeLinks.v1(book: book)
end
