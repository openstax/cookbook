# frozen_string_literal: true

module Kitchen::Directions::BakeNumberedExercise
  class V1
    # rubocop:disable Metrics/ParameterLists
    def bake(exercise:, number:, suppress_solution_if:,
             note_suppressed_solutions:, cases:, solution_stays_put:)
      problem = exercise.problem
      solution = exercise.solution

      in_appendix = exercise.has_ancestor?(:page) && exercise.ancestor(:page).has_class?('appendix')

      # Store label information
      if in_appendix
        label_number = number
        title_label = "<span class=\"os-title-label\">#{I18n.t('exercise')}</span>"
        problem_divider = ''
      else
        label_number = "#{exercise.ancestor(:chapter).count_in(:book)}.#{number}"
        title_label = ''
        problem_divider = "<span class='os-divider'>. </span>"
      end

      exercise.target_label(label_text: 'exercise', custom_content: label_number, cases: cases)

      problem_number = "<span class='os-number'>#{number}</span>"

      suppress_solution =
        case suppress_solution_if
        when Symbol
          number.send(suppress_solution_if)
        else
          suppress_solution_if
        end

      if solution.present?
        if suppress_solution
          solution.trash
          exercise.add_class('os-hasSolution-trashed') if note_suppressed_solutions
        else
          problem_number = \
            if solution_stays_put || in_appendix
              "<span class='os-number'>#{number}</span>"
            else
              "<a class='os-number' href='##{exercise.id}-solution'>#{number}</a>"
            end
          bake_solution(
            exercise: exercise,
            number: number,
            solution_stays_put: solution_stays_put,
            in_appendix: in_appendix
          )
        end
      end

      problem.replace_children(with:
        <<~HTML
          #{title_label}
          #{problem_number}
          #{problem_divider}
          <div class="os-problem-container">#{problem.children}</div>
        HTML
      )
    end
    # rubocop:enable Metrics/ParameterLists

    def bake_solution(exercise:, number:, solution_stays_put:, divider: '. ', in_appendix: false)
      solution = exercise.solution
      if solution_stays_put
        solution.wrap_children(class: 'os-solution-container')
        solution.prepend(child:
          <<~HTML
            <h4 class="solution-title" data-type="title">
              <span class="os-text">#{I18n.t(:solution)}</span>
            </h4>
          HTML
        )
        return
      end

      solution.id = "#{exercise.id}-solution"
      exercise.add_class('os-hasSolution')

      if in_appendix
        solution.wrap_children(class: 'os-solution-container')
        return
      end

      solution.replace_children(with:
        <<~HTML
          <a class='os-number' href='##{exercise.id}'>#{number}</a>
          <span class='os-divider'>#{divider}</span>
          <div class="os-solution-container">#{solution.children}</div>
        HTML
      )
    end
  end
end
