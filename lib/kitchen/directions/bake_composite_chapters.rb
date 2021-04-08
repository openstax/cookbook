# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeCompositeChapters
      def self.v1(book:)
        book.search("[data-type='composite-chapter']").each do |chapter|
          chapter.first("[data-type='document-title']").id =
            "composite-chapter-#{chapter.count_in(:book)}"
        end
      end
    end
  end
end
