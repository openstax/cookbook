# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeNumberedExercise
      def self.v1(exercise:, number:, options: {})
        # any option that is passed in will override the defaults,
        # but if some options not given, default will be used.
        options.reverse_merge!(
          suppress_solution_if: false,
          note_suppressed_solutions: false,
          cases: false,
          solution_stays_put: false
        )
        V1.new.bake(exercise: exercise, number: number, options: options)
      end

      def self.bake_solution_v1(exercise:, number:, divider: '. ')
        V1.new.bake_solution(exercise: exercise, number: number, divider: divider,
                             solution_stays_put: false)
      end
    end
  end
end
