# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeNoteInjectedQuestion
      def self.v1(note:, question:)
        question.add_class('unnumbered')
        number = note.first('.os-number').text.gsub(/#/, '')
        Kitchen::Directions::BakeInjectedExerciseQuestion.v1(
          question: question, number: number, only_number_solution: true
        )
      end
    end
  end
end
