# frozen_string_literal: true

# Python answer key strategy
class Strategy
  def bake(chapter:, append_to:)
    chapter.non_introduction_pages.each do |page|
      title = page.title.children
      Kitchen::Directions::MoveSolutionsFromAutotitledNote.v1(
        page: page, append_to: append_to, note_class: 'learning-questions', title: title)
    end
  end
end
