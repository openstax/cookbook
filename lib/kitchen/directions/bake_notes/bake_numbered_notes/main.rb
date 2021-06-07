# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeNumberedNotes
      def self.v1(book:, classes:)
        V1.new.bake(book: book, classes: classes)
      end

      def self.v2(book:, classes:)
        V2.new.bake(book: book, classes: classes)
      end

      # Used by V1, V2
      def self.bake_note_exercise(note:, exercise:, divider: ' ')
        exercise.add_class('unnumbered')
        # bake problem
        exercise.problem.wrap_children('div', class: 'os-problem-container')
        exercise.search('[data-type="commentary"]').each(&:trash)
        return unless exercise.solution

        # bake solution in place
        BakeNumberedExercise.bake_solution_v1(
          exercise: exercise, number: note.first('.os-number').text.gsub(/#/, ''), divider: divider)
      end
    end
  end
end
