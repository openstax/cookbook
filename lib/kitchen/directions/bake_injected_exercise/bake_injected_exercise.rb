# frozen_string_literal: true

module Kitchen::Directions::BakeInjectedExercise
  def self.v1(exercise:, alphabetical_multiparts: false)
    V1.new.bake(exercise: exercise, alphabetical_multiparts: alphabetical_multiparts)
  end

  class V1
    def bake(exercise:, alphabetical_multiparts:)
      question_count = exercise.injected_questions.count

      context = exercise&.exercise_context
      stimulus = exercise&.first("div[data-type='exercise-stimulus']")

      # To handle alphabetical multipart questions without interrupting numbering
      if alphabetical_multiparts && stimulus
        question_count = 1
        solutions_clipboard = Kitchen::Clipboard.new
        questions_clipboard = Kitchen::Clipboard.new
        alphabet = *('a'..'z')
        wrapper_id = "#{exercise.injected_questions.first.id}-wrapper"

        exercise.injected_questions.each_with_index do |question, index|
          question.set(:'data-type', 'alphabetical-question-multipart')
          question.add_class('alphabetical-multipart')
          problem_letter = "(#{alphabet[index]})"

          solution = question.solution
          solution_id = "#{question.id}-solution" if solution.present?

          question.prepend(child:
            <<~HTML
              <div class="os-problem-container">
                <a class='problem-letter' #{"href=##{solution_id}" if solution.present?}>#{problem_letter}</a>
                <span class='os-divider'> </span>
                #{question.stimulus&.cut&.paste}
                #{question.stem&.cut&.paste}
              </div>
            HTML
          )

          question&.cut(to: questions_clipboard)

          next unless solution

          solution.replace_children(with:
            <<~HTML
              <a class='problem-letter' href='##{solution_id}'>#{problem_letter}</a>
              <span class='os-divider'> </span>
              <div class="os-solution-container">#{question.solution&.children}</div>
            HTML
          )
          solution.set(:'data-type', 'solution-part')
          solution.cut(to: solutions_clipboard)
        end

        stimulus.set(:'data-type', 'question-stimulus')
        solution_block = if solutions_clipboard.any?
                           <<~HTML
                             <div data-type="question-solution" id='#{wrapper_id}-solution'>
                               #{solutions_clipboard.paste}
                             </div>
                           HTML
                         end

        exercise&.prepend(child:
          <<~HTML
            <div data-type='exercise-question' id='#{wrapper_id}'>
              #{stimulus&.cut&.paste}
              #{questions_clipboard.paste}
              #{solution_block}
            </div>
          HTML
        )

      end

      exercise[:'data-question-count'] = question_count
      exercise[:'data-is-multipart'] = question_count > 1 ? 'True' : 'False'

      return unless context

      # link replacement is done by BakeLinkPlaceholders
      link = context.first('a').cut
      context.replace_children(with: "#{I18n.t(:context_lead_text)}#{link.paste}")
      return unless question_count == 1

      question = exercise.exercise_question
      question.prepend(child: context.cut.paste)
    end
  end
end
