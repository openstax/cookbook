# frozen_string_literal: true

module Kitchen::Directions::BakeNumberedExercise
  class V1
    def bake(exercise:, number:)
      problem = exercise.problem
      solution = exercise.solution

      problem_number = "<span class='os-number'>#{number}</span>"

      if solution.present?
        solution.id = "#{exercise.id}-solution"
        exercise.add_class('os-hasSolution')
        problem_number = "<a class='os-number' href='##{exercise.id}-solution'>#{number}</a>"

        solution.replace_children(with:
          <<~HTML
            <a class='os-number' href='##{exercise.id}'>#{number}</a>
            <span class='os-divider'>. </span>
            <div class="os-solution-container">#{solution.children}</div>
          HTML
        )
      end

      problem.replace_children(with:
        <<~HTML
          #{problem_number}
          <span class='os-divider'>. </span>
          <div class="os-problem-container">#{problem.children}</div>
        HTML
      )
    end
  end
end
