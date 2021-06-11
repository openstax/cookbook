# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeFootnotes
      def self.v1(book:, number_format: :arabic)
        V1.new.bake(book: book, number_format: number_format)
      end
    end
  end
end
