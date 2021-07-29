# frozen_string_literal: true

module Kitchen::Directions::MoveSolutionsToAnswerKey
  module Strategies
    class ContemporaryMath
      def bake(chapter:, append_to:)
        solutions_clipboard = Kitchen::Clipboard.new
        chapter.notes('$.your-turn').exercises.each do |exercise|
          solution = exercise.solution
          next unless solution

          # Hacky numbering fix
          number = exercise.ancestor(:note).count_in(:chapter)
          solution.first('a.os-number').inner_html = number.to_s
          solution.first('span.os-divider').inner_html = '. '
          solution.cut(to: solutions_clipboard)
        end
        title = <<~HTML
          <h3 data-type="title">
            <span class="os-title-label">#{I18n.t(:'notes.your-turn')}</span>
          </h3>
        HTML
        append_solution_area(title: title, solutions: solutions_clipboard,
                             append_to: append_to)
      end

      def append_solution_area(title:, solutions:, append_to:)
        append_to = append_to.add_child(
          <<~HTML
            <div class="os-solution-area">
              #{title}
            </div>
          HTML
        ).first

        append_to.add_child(solutions.paste)
      end
    end
  end
end
