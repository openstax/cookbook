# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeFolio
      def self.v1(book:, chapters: nil, options: {})
        options.reverse_merge!(
          new_approach: false,
          numbering_options: { mode: :chapter_page, separator: '.' })
        V1.new.bake(
          book: book,
          chapters: chapters || book.chapters,
          options: options)
      end

      def self.v2(book:, chapters: nil)
        V2.new.bake(book: book, chapters: chapters || book.chapters)
      end
    end
  end
end
