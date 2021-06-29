# frozen_string_literal: true

module Kitchen::Directions::MoveSolutionsToAnswerKey
  module Strategies
    class Calculus
      def bake(chapter:, append_to:)
        checkpoint_solutions = chapter.search('div.checkpoint div[data-type="solution"]').cut
        append_solution_area(I18n.t(:checkpoint), checkpoint_solutions, append_to)

        chapter.search('section.section-exercises').each do |section|
          section_solutions = section.search('div[data-type="solution"]').cut
          section_title = I18n.t(
            :section_exercises,
            number: "#{chapter.count_in(:book)}.#{section.count_in(:chapter)}"
          )
          append_solution_area(section_title, section_solutions, append_to)
        end

        chapter.search('section.review-exercises').each do |section|
          section_solutions = section.search('div[data-type="solution"]').cut
          append_solution_area(I18n.t(:review_exercises), section_solutions, append_to)
        end
      end

      protected

      def append_solution_area(title, clipboard, append_to)
        append_to.add_child(
          <<~HTML
            <div class="os-solution-area">
              <h3 data-type="title">
                <span class="os-title-label">#{title}</span>
              </h3>
              #{clipboard.paste}
            </div>
          HTML
        )
      end
    end
  end
end
