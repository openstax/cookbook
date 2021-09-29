# frozen_string_literal: true

module Kitchen
  module Directions
    # Ids should be added before exercises are moved to EOC,
    # since they're using part of the ancestor page id.
    #
    # In some books exercises are numbered after moving.
    # That's why this step has to be separated from BakeInjectedExerciseQuestion
    module AddInjectedExerciseId
      def self.v1(book:)
        book.pages.injected_questions.each(&:id)
      end
    end
  end
end
