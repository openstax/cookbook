# frozen_string_literal: true

module Kitchen::Directions::BakeInjectedExercise
  def self.v1(exercise:, alphabetical_multiparts: false)
    V1.new.bake(exercise: exercise, alphabetical_multiparts: alphabetical_multiparts)
  end

  class V1
    def bake(exercise:, alphabetical_multiparts:)
      question_count = exercise.injected_questions.count
      exercise[:'data-question-count'] = question_count
      exercise[:'data-is-multipart'] = question_count > 1 ? 'True' : 'False'

      context = exercise&.exercise_context
      stimulus = exercise&.first("div[data-type='exercise-stimulus']")

      # To handle alphabetical multipart questions without interrupting numbering
      if alphabetical_multiparts && stimulus
        solutions_clipboard = Kitchen::Clipboard.new
        questions_clipboard = Kitchen::Clipboard.new
        alphabet = *('a'..'z')
        wrapper_id = "#{exercise.injected_questions.first.id}-wrapper"

        exercise.injected_questions.each_with_index do |question, index|
          question.set(:'data-type', 'alphabetical-question-multipart')
          question.add_class('alphabetical-multipart')
          problem_letter = "(#{alphabet[index]})"

          question.prepend(child:
            <<~HTML
              <div class="os-problem-container">
                <a class='problem-letter' #{"href=##{question.id}-solution" if question.id.present?}>#{problem_letter}</a>
                <span class='os-divider'> </span>
                #{question.stimulus&.cut&.paste}
                #{question.stem&.cut&.paste}
              </div>
            HTML
          )

          solution = question.solution
          solution_id = "#{question.id}-solution"
          solution&.replace_children(with:
            <<~HTML
              <a class='problem-letter' href='##{solution_id}'>#{problem_letter}</a>
              <span class='os-divider'> </span>
              <div class="os-solution-container">#{question.solution&.children}</div>
            HTML
          )
          solution&.set(:'data-type', 'solution-part')
          solution&.cut(to: solutions_clipboard)
          question&.cut(to: questions_clipboard)
        end

        stimulus.set(:id, wrapper_id)
        stimulus.set(:'data-type', 'exercise-question')

        stimulus&.replace_children(with:
          <<~HTML
            <div data-type="question-stimulus">#{stimulus.children}</div>
            #{questions_clipboard.paste}
            <div data-type="question-solution" id='##{wrapper_id}-solution'>
            #{solutions_clipboard.paste}
            </div>
          HTML
        )

      end

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
