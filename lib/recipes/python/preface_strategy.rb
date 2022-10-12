# frozen_string_literal: true

# Python preface answer key strategy
class PrefaceStrategy
  def bake(page:, append_to:)
    Kitchen::Directions::MoveSolutionsFromAutotitledNote.v1(
      page: page, append_to: append_to, note_class: 'learning-questions', title: nil)
  end
end
