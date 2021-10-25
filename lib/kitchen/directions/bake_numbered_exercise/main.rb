# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeNumberedExercise
      # rubocop:disable Metrics/ParameterLists
      # :/
      def self.v1(exercise:, number:, suppress_solution_if: false,
                  note_suppressed_solutions: false, cases: false, solution_stays_put: false)
        V1.new.bake(exercise: exercise, number: number, suppress_solution_if: suppress_solution_if,
                    note_suppressed_solutions: note_suppressed_solutions, cases: cases,
                    solution_stays_put: solution_stays_put)
      end
      # rubocop:enable Metrics/ParameterLists

      def self.bake_solution_v1(exercise:, number:, divider: '. ')
        V1.new.bake_solution(exercise: exercise, number: number, divider: divider,
                             solution_stays_put: false)
      end
    end
  end
end
