# frozen_string_literal: true

module Kitchen::Directions::BakeAutotitledExercise
  # Differences from V2:
  # 1. Exercise with solution has class os-hasSolution
  # 2. Solution id is based on exercise id
  class V3
    def bake(exercise:, title:)
      exercise.add_class('unnumbered')
      exercise.titles.first&.trash

      # bake problem
      exercise.prepend(child:
        <<~HTML
          <h3 class="os-title" data-type="title">
            <span class="os-title-label">#{title}</span>
          </h3>
        HTML
      )
      exercise.problem.wrap_children(class: 'os-problem-container')
      return unless exercise.solution

      exercise.add_class('os-hasSolution')
      exercise.solution.id = "#{exercise.id}-solution"
      exercise.solution.wrap_children(class: 'os-solution-container')
      exercise.solution.prepend(child:
        <<~HTML
          <h4 class="solution-title" data-type="title">
            <span class="os-text">#{I18n.t(:solution)}</span>
          </h4>
        HTML
      )
    end
  end
end
