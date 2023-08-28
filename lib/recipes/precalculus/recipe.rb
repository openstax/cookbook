# frozen_string_literal: true

PRECALCULUS_COREQ_DELETE_RECIPE = Kitchen::BookRecipe.new(book_short_name: :coreq_delete) do |doc|
  include Kitchen::Directions

  book = doc.book

  book.search('section.practice-perfect').each(&:trash)
  book.search('section.coreq-skills').each(&:trash)
end
