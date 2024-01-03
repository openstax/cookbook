# frozen_string_literal: true

INFORMATION_SYSTEMS_RECIPE = Kitchen::BookRecipe.new(book_short_name: :info_sys) \
do |doc, _resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  BakeFolio.v1(book: book)
end
