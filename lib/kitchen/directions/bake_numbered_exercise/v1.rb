# frozen_string_literal: true

module Kitchen::Directions::BakeNumberedExercise
  class V1
    def bake(exercise:, number:, suppress_solution_if: false, note_suppressed_solutions: false)
      problem = exercise.problem
      solution = exercise.solution

      exercise.pantry(name: :link_text).store(
        "#{I18n.t(:exercise_label)} #{exercise.ancestor(:chapter).count_in(:book)}.#{number}",
        label: exercise.id
      )
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
          problem_number = "<a class='os-number' href='##{exercise.id}-solution'>#{number}</a>"
          bake_solution(exercise: exercise, number: number)
        end
      end

      problem.replace_children(with:
        <<~HTML
          #{problem_number}
          <span class='os-divider'>. </span>
          <div class="os-problem-container">#{problem.children}</div>
        HTML
      )

      # Bake multipart questions
      multipart_questions = problem.search('div.question-stem')
      return unless multipart_questions.count > 1

      multipart_clipboard = Kitchen::Clipboard.new
      multipart_questions.each do |question|
        question.wrap('<li>')
        question = question.parent
        question.cut(to: multipart_clipboard)
      end

      problem.first('div.question-stimulus, div.exercise-stimulus').append(sibling:
        <<~HTML
          <ol type="a">
            #{multipart_clipboard.paste}
          </ol>
        HTML
      )
    end

    def bake_solution(exercise:, number:, divider: '. ')
      solution = exercise.solution
      solution.id = "#{exercise.id}-solution"
      exercise.add_class('os-hasSolution')

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
