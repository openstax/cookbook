# frozen_string_literal: true

module Kitchen
  module Directions
    module BookAnswerKeyContainer
      def self.v1(book:, solutions_plural: true)
        V1.new.bake(book: book, solutions_plural: solutions_plural)
      end
    end
  end
end
