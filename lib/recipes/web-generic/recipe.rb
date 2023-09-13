# frozen_string_literal: true

WEB_RECIPE = Kitchen::BookRecipe.new(book_short_name: :web) do |doc, resources|
  include Kitchen::Directions

  book = doc.book

  BakeImages.v1(book: book, resources: resources)
end
