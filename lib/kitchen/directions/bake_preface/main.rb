# frozen_string_literal: true

module Kitchen
  module Directions
    module BakePreface
      def self.v1(book:, title_element:)
        V1.new.bake(book: book, title_element: title_element)
      end
    end
  end
end
