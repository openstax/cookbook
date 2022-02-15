# frozen_string_literal: true

# Marketing answer key strategy
class Strategy
  def bake(chapter:, append_to:)
    # Bake section exercises
    chapter.non_introduction_pages.each do |page|
      number = "#{chapter.count_in(:book)}.#{page.count_in(:chapter)}"
      Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
        chapter: page, append_to: append_to, section_class: 'knowledge-check',
        title_number: number
      )
    end
  end
end
