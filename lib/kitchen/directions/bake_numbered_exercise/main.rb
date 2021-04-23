# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeNumberedExercise
      def self.v1(exercise:, number:)
        V1.new.bake(exercise: exercise, number: number)
      end

      def self.bake_solution_v1(exercise:, number:, divider: '. ')
        V1.new.bake_solution(exercise: exercise, number: number, divider: divider)
      end
    end
  end
end
