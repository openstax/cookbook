# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeIndex
      def self.v1(book:,
                  chapters: nil,
                  types: %w[main],
                  uuid_prefix: nil,
                  numbering_options: { mode: :chapter_page, separator: '.' })
        V1.new.bake(
          book: book,
          chapters: chapters || book.chapters,
          types: types,
          uuid_prefix: uuid_prefix,
          numbering_options: numbering_options)
      end
    end
  end
end
