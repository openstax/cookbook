# frozen_string_literal: true

# Accounting answer key strategy
class Strategy
  def bake(chapter:, append_to:)
    classes = %w[multiple-choice questions]
    classes.each do |klass|
      Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
        chapter: chapter, append_to: append_to, section_class: klass
      )
    end
  end
end
