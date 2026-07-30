# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeNumberedNotes
      def self.v1(book:, classes:, options: {
        cases: false,
        bake_exercises: true
      })
        options.reverse_merge!(
          cases: false,
          bake_exercises: true
        )
        V1.new.bake(book: book, classes: classes, options: options)
      end

      def self.v2(book:, classes:)
        V2.new.bake(book: book, classes: classes)
      end

      # V3 bakes notes tied to an example immediately previous ("Try It" notes)
      # Must be called AFTER BakeExercises
      #
      def self.v3(book:, classes:, options: { suppress_solution: true })
        options.reverse_merge!(suppress_solution: true)
        V3.new.bake(book: book, classes: classes, options: options)
      end

      # V4 bakes notes scoped to descendants of a given container selector,
      # numbered relative to the given scope (e.g. :chapter).
      #
      def self.v4(book:, classes:, within:, scope: :chapter)
        V4.new.bake(book: book, classes: classes, within: within, scope: scope)
      end
    end
  end
end
