# frozen_string_literal: true

NEUROSCIENCE_RECIPE = Kitchen::BookRecipe.new(book_short_name: :neuroscience) do |doc, _resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  BakePreface.v1(book: book)
  BakeChapterTitle.v1(book: book)
  #BakeToc.v1(book: book)
  BakeIndex.v1(book: book)
end
