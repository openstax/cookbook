# frozen_string_literal: true

module Kitchen::Directions::MoveSolutionsToAnswerKey
  module Strategies
    class UPhysics
      def bake(chapter:, append_to:)
        Kitchen::Directions::MoveSolutionsFromNumberedNote.v1(
          chapter: chapter, append_to: append_to, note_class: 'check-understanding'
        )

        classes = %w[review-conceptual-questions review-problems review-additional-problems
                     review-challenge]
        classes.each do |klass|
          Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
            chapter: chapter, append_to: append_to, section_class: klass
          )
        end
      end
    end
  end
end
