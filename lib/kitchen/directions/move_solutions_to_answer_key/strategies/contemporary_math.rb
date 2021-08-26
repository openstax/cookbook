# frozen_string_literal: true

module Kitchen::Directions::MoveSolutionsToAnswerKey
  module Strategies
    class ContemporaryMath
      def bake(chapter:, append_to:)
        # Hacky numbering fix
        chapter.notes('$.your-turn').exercises.each do |exercise|
          solution = exercise.solution
          next unless solution

          number = exercise.ancestor(:note).count_in(:chapter)
          solution.first('a.os-number').inner_html = number.to_s
          solution.first('span.os-divider').inner_html = '. '
        end

        Kitchen::Directions::MoveSolutionsFromNumberedNote.v1(
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
        classes = %w[chapter-review chapter-test]
        classes.each do |klass|
          Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
            chapter: chapter, append_to: append_to, section_class: klass
          )
        end
      end
    end
  end
end
