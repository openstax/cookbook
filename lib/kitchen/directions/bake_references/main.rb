# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for EOB references
    #
    module BakeReferences
      def self.v1(book:, metadata_source:, numbered_title: false)
        V1.new.bake(book: book, metadata_source: metadata_source, numbered_title: numbered_title)
      end

      def self.v2(book:, metadata_source:)
        V2.new.bake(book: book, metadata_source: metadata_source)
      end

      def self.v3(book:, metadata_source:)
        V3.new.bake(book: book, metadata_source: metadata_source)
      end

      def self.v4(book:, metadata_source:, chapters: nil, cases: false, numbering_options: {})
        numbering_options.reverse_merge!(mode: :chapter_page, separator: '.')
        V4.new.bake(
          book: book,
          chapters: chapters || book.chapters,
          metadata_source: metadata_source,
          cases: cases,
          numbering_options: numbering_options)
      end
    end
  end
end
