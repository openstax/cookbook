# frozen_string_literal: true

# Marketing appendix answer key strategy
class AppendixStrategy
  def bake(page:, append_to:)
    Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
      chapter: page, append_to: append_to, section_class: 'knowledge-check', in_appendix: true)
  end
end
