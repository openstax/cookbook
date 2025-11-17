# frozen_string_literal: true

require_relative '../kitchen/book_recipe'

POST_BAKE = Kitchen::BookRecipe.new(book_short_name: :post_bake) do |doc|
  book = doc.book

  BakeOrderHeaders.v2(within: book)
end
