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
            exercise_options[:exercise] = exercise
            exercise_options[:number] = exercise_counter
            BakeNumberedExercise.v1(exercise_options)
          else
            question_options[:number] = exercise_counter
            question_options[:question] = exercise
            BakeInjectedExerciseQuestion.v1(question_options)
          end
          exercise_counter += 1
        end
      end
    end
  end
end
