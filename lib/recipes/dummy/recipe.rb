# frozen_string_literal: true

# Hardcode locale = 'en' because CNX books contain other languages (vi, af, ru, de, ...) and no text is injected when baking them.
module Kitchen
  # Monkeypatched
  class Document
    def locale
      'en'
    end
  end
end

DUMMY_RECIPE = Kitchen::BookRecipe.new(book_short_name: :dummy) do |doc, resources|
  include Kitchen::Directions

  book = doc.book
  book.search('div.test123').each { |div| div.replace_children(with: 'Hello, world!') }

  BakeImages.v1(book: book, resources: resources)
end
