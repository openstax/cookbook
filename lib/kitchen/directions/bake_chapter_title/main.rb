# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeChapterTitle
      def self.v1(book:, cases: false)
        V1.new.bake(book: book, cases: cases)
      end
    end
  end
end
