# frozen_string_literal: true

INFORMATION_SYSTEMS_RECIPE = Kitchen::BookRecipe.new(book_short_name: :info_sys) \
do |doc, _resources|
  include Kitchen::Directions

  book = doc.book
  _metadata = book.metadata

  book.search('cnx-pi').trash

  BakePreface.v1(book: book)
  BakeUnnumberedFigure.v1(book: book)
  BakeUnnumberedTables.v1(book: book)

  BakeUnitTitle.v1(book: book)
  BakeChapterTitle.v1(book: book)
  BakeChapterIntroductions.v1(book: book)

  BakeAutotitledNotes.v1(
    book: book,
    classes: %w[future-tech global-connect is-ethics is-careers link-to-learning]
  )

  book.chapters.each do |chapter|
    BakeNonIntroductionPages.v1(chapter: chapter)

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}")
    end

    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}")
    end
  end

  # Appendix
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

  BakeTableColumns.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeRexWrappers.v1(book: book)
  BakeLinks.v1(book: book)
end