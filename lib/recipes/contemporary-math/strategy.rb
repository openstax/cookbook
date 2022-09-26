# frozen_string_literal: true

# Contemporary answer key strategy
class Strategy
  def bake(chapter:, append_to:)
    # Hacky numbering fix
    Kitchen::Directions::MoveSolutionsFromNumberedNote.v2(
      chapter: chapter, append_to: append_to, note_class: 'your-turn'
    )

    # Bake section exercises
    chapter.non_introduction_pages.each do |page|
      number = "#{chapter.count_in(:book)}.#{page.count_in(:chapter)}"
      Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
        chapter: page, append_to: append_to, section_class: 'section-exercises',
        title_number: number
      )
    end

    # Bake other exercise sections
    classes = %w[chapter-review chapter-test check-understanding]
    classes.each do |klass|
      Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
        chapter: chapter, append_to: append_to, section_class: klass
      )
    end
  end
end
