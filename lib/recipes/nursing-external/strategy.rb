# frozen_string_literal: true

# Contemporary answer key strategy
class Strategy
  def bake(chapter:, append_to:)
    # Hacky numbering fix
    Kitchen::Directions::MoveSolutionsFromNumberedNote.v1(
      chapter: chapter, append_to: append_to, note_class: 'unfolding-casestudy'
    )
    Kitchen::Directions::MoveSolutionsFromNumberedNote.v1(
      chapter: chapter, append_to: append_to, note_class: 'single-casestudy'
    )
    # Bake other exercise sections

    Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
      chapter: chapter, append_to: append_to, section_class: 'review-questions')
  end
end
