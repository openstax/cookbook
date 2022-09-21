# frozen_string_literal: true

# Marketing appendix answer key strategy
class AppendixStrategy
  def bake(page:, append_to:)
    Kitchen::Directions::MoveSolutionsFromNumberedNote.v1(
      chapter: page,
      append_to: append_to,
      note_class: 'your-turn'
    )
  end
end
