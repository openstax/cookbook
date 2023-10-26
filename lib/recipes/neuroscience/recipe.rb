# frozen_string_literal: true

NEUROSCIENCE_RECIPE = Kitchen::BookRecipe.new(book_short_name: :neuroscience) do |doc, resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  # Some stuff just goes away
  book.search('cnx-pi').trash

  BakePreface.v1(book: book)

  BakeChapterTitle.v1(book: book)



  # BakeFootnotes.v1(book: book)
  # BakeEquations.v1(book: book)
  # BakeIndex.v1(book: book)
  # BakeCompositePages.v1(book: book)
  # BakeCompositeChapters.v1(book: book)
  # BakeToc.v1(book: book)
  # BakeLinkPlaceholders.v1(book: book)
  # BakeFolio.v1(book: book)
  # BakeLinks.v1(book: book)
end
