# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeChapterTitle
      def self.v1(book:, cases: false)
        V1.new.bake(book: book, cases: cases)
      end

      def self.v2(chapters:, cases: false, numbering_options: {})
        V2.new.bake(chapters: chapters, cases: cases, numbering_options: numbering_options)
      end
    end
  end
end
