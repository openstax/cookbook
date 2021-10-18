# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeNumberedNotes
      def self.v1(book:, classes:, cases: false)
        V1.new.bake(book: book, classes: classes, cases: cases)
      end

      def self.v2(book:, classes:)
        V2.new.bake(book: book, classes: classes)
      end

      # V3 bakes notes tied to an example immediately previous ("Try It" notes)
      # Must be called AFTER BakeExercises
      #
      def self.v3(book:, classes:, suppress_solution: true)
        V3.new.bake(book: book, classes: classes, suppress_solution: suppress_solution)
      end
    end
  end
end
