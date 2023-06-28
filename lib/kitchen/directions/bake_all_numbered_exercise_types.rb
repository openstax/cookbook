# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeAllNumberedExerciseTypes
      def self.v1(within:, exercise_options: {}, question_options: {})
        exercise_counter = 1
        within.search_with(ExerciseElementEnumerator, InjectedQuestionElementEnumerator)\
              .each do |exercise|
          next if exercise.has_class?('unnumbered')

          if exercise.instance_of?(ExerciseElement)
            BakeNumberedExercise.v1(
              exercise: exercise, number: exercise_counter, options: exercise_options
            )
          else
            BakeInjectedExerciseQuestion.v1(number: exercise_counter, question: exercise)
          end
          exercise_counter += 1
        end
      end
    end
  end
end
