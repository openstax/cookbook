# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeUnnumberedExercise
      def self.v1(exercise:)
        exercise.problem.wrap_children(class: 'os-problem-container')
        return unless exercise.solution

        exercise.solutions.each do |solution|
          solution.wrap_children(class: 'os-solution-container')
        end
      end
    end
  end
end
