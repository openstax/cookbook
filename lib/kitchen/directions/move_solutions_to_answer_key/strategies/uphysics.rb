# frozen_string_literal: true

module Kitchen::Directions::MoveSolutionsToAnswerKey
  module Strategies
    class UPhysics
      def bake(chapter:, append_to:)
        bake_from_notes(chapter: chapter, append_to: append_to, klass: 'check-understanding')

        classes = %w[review-conceptual-questions review-problems review-additional-problems
                     review-challenge]
        classes.each do |klass|
          bake_section(chapter: chapter, append_to: append_to, klass: klass)
        end
      end

      protected

      def bake_section(chapter:, append_to:, klass:)
        section_solutions_set = []
        chapter.search(".#{klass}").each do |section|
          section.search('[data-type="solution"]').each do |solution|
            section_solutions_set.push(solution.cut)
          end
        end

        return if section_solutions_set.empty?

        title = I18n.t(:"eoc.#{klass}")
        append_solution_area(title, section_solutions_set, append_to)
      end

      def bake_from_notes(chapter:, append_to:, klass:)
        solutions = []
        chapter.notes(".#{klass}").each do |note|
          solution = note.exercises.first.solution
          solutions.push(solution.cut) if solution
        end
        return if solutions.empty?

        title = I18n.t(:"notes.#{klass}")
        append_solution_area(title, solutions, append_to)
      end

      def append_solution_area(title, solutions, append_to)
        append_to = append_to.add_child(
          <<~HTML
            <div class="os-solution-area">
              <h3 data-type="title">
                <span class="os-title-label">#{title}</span>
              </h3>
            </div>
          HTML
        ).first

        solutions.each do |solution|
          append_to.add_child(solution.raw)
        end
      end
    end
  end
end
