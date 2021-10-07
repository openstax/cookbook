# frozen_string_literal: true

module Kitchen::Directions::BakeAutotitledExercise
  # Differences from V1:
  # 1. Title is an <h3><span>, not <h4>, & above the problem instead of within it
  # 2. Title is generated in the recipe and passed to the method
  class V2
    def bake(exercise:, title:)
      exercise.add_class('unnumbered')
      exercise.titles.first&.trash

      # bake problem
      exercise.prepend(child:
        <<~HTML
          <h3 class="os-title">
            <span class="os-title-label">#{title}</span>
          </h3>
        HTML
      )
      exercise.problem.wrap_children(class: 'os-problem-container')
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
