# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeNoteExercise
      def self.v1(note:, exercise:, divider: ' ', suppress_solution: false)
        exercise.add_class('unnumbered')
        number = note.first('.os-number').text.gsub(/#/, '')

        # bake problem
        exercise.problem.wrap_children('div', class: 'os-problem-container')
        exercise.search('[data-type="commentary"]').each(&:trash)
        return unless exercise.solution

        # bake solution in place
        if suppress_solution
          exercise.add_class('os-hasSolution')
          exercise.solution.trash
        else
          BakeNumberedExercise.bake_solution_v1(
            exercise: exercise,
            number: number,
            divider: divider
          )
        end
      end

      def self.v2(note:)
        note.exercises.each do |exercise|
          exercise.problem.wrap_children('div', class: 'os-problem-container')

          unless exercise.has_class?('unnumbered')
            exercise.problem.prepend(child:
              <<~HTML
                <span class="os-title-label">#{I18n.t(:"exercises.exercise")} </span>
                <span class="os-number">#{exercise.count_in(:note)}</span>
              HTML
            )
          end

          next unless exercise.solution

          exercise.solution.wrap_children('div', class: 'os-solution-container')

          exercise.solution.prepend(child:
            <<~HTML
              <span class="os-title-label">#{I18n.t(:"exercises.solution")}</span>
            HTML
          )
        end
      end
    end
  end
end
