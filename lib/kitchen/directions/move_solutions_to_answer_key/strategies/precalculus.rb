# frozen_string_literal: true

module Kitchen::Directions::MoveSolutionsToAnswerKey
  module Strategies
    class Precalculus
      def bake(chapter:, append_to:)
        try_note_solutions(chapter: chapter, append_to: append_to)

        # Bake section exercises
        chapter.non_introduction_pages.each do |page|
          number = "#{chapter.count_in(:book)}.#{page.count_in(:chapter)}"
          Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
            chapter: page, append_to: append_to, section_class: 'section-exercises',
            title_number: number
          )
        end

        # Bake other types of exercises
        classes = %w[review-exercises practice-test]
        classes.each do |klass|
          Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
            chapter: chapter, append_to: append_to, section_class: klass
          )
        end
      end

      protected

      def try_note_solutions(chapter:, append_to:)
        append_to.append(child:
          <<~HTML
            <div class="os-module-reset-solution-area os-try-solution-area">
              <h3 data-type="title">
                <span class="os-title-label">#{I18n.t(:"notes.try")}</span>
              </h3>
            </div>
          HTML
        )
        chapter.pages.each do |page|
          solutions = Kitchen::Clipboard.new
          page.notes('$.try').each do |note|
            note.exercises.each do |exercise|
              solution = exercise.solution
              solution&.cut(to: solutions)
            end
          end
          next if solutions.items.empty?

          title_snippet = Kitchen::Directions::EocSectionTitleLinkSnippet.v1(
            page: page,
            wrapper: 'div'
          )

          append_to.first('div.os-try-solution-area').append(child:
            Kitchen::Directions::SolutionAreaSnippet.v1(
              title: title_snippet, solutions_clipboard: solutions
            )
          )
        end
      end
    end
  end
end
