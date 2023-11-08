# frozen_string_literal: true

WEB_RECIPE = Kitchen::BookRecipe.new(book_short_name: :web) do |doc, _resources|
  include Kitchen::Directions

  _book = doc.book

  # BakeImages.v1(book: book, resources: resources)
end
