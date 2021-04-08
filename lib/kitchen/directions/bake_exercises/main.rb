# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeExercises
      def self.v1(book:)
        warn 'WARNING! deprecated direction used: BakeExecises'
        V1.new.bake(book: book)
      end
    end
  end
end
