# frozen_string_literal: true

# U-physics answer key strategy
class Strategy
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
