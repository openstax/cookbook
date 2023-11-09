# frozen_string_literal: true

require 'byebug'

module Kitchen::Directions::BakeRexWrappers
  class V1
    def bake(book:)
      book.search('body').first[:"data-book-content"] = 'true'

      book.pages.each do |page|
        page[:"data-book-content"] = 'true'
      end

      book.composite_pages.each do |page|
        page[:"data-book-content"] = 'true'
      end
    end
  end
end
