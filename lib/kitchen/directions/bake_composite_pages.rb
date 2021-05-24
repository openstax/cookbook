# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeCompositePages
      def self.v1(book:)
        book.composite_pages.each do |page|
          page.id = "composite-page-#{page.count_in(:book)}"
        end
      end
    end
  end
end
