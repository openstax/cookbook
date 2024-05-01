# frozen_string_literal: true

module Kitchen::Directions::BakeInjectedExercise
  def self.v1(exercise:, options: {
    alphabetical_multiparts: false,
    list_type: nil,
    add_brackets: false
  })
    options.reverse_merge!(
      alphabetical_multiparts: false,
      list_type: nil,
      add_brackets: false
    )
    V1.new.bake(exercise: exercise, options: options)
  end

  class V1
    def bake(exercise:, options:)
      question_count = exercise.injected_questions.count

      context = exercise&.exercise_context
      stimulus = exercise&.first("div[data-type='exercise-stimulus']")

      # To handle alphabetical multipart questions without interrupting numbering
      if options[:alphabetical_multiparts] && stimulus
        question_count = 1
        solutions_clipboard = Kitchen::Clipboard.new
        questions_clipboard = Kitchen::Clipboard.new
        wrapper_id = "#{exercise.injected_questions.first.id}-wrapper"

        if options[:list_type] == 'lower-alpha'
          alphabet = *('a'..'z')
        elsif options[:list_type] == 'upper-alpha'
          alphabet = *('A'..'Z')
        end

        exercise.injected_questions.each_with_index do |question, index|
          question.set(:'data-type', 'alphabetical-question-multipart')
          id = question.id

          problem_letter = if options[:add_brackets]
                             "(#{alphabet[index]})"
                           else
                             "#{alphabet[index]}."
                           end

          problem_letter_tag = \
            if question.solution.present?
              "<a class='problem-letter' href='##{id}-solution'>#{problem_letter}</a>"
            else
              "<span class='problem-letter'>#{problem_letter}</span>"
            end

          question.prepend(child:
            <<~HTML
              <div class="os-problem-container">
                #{problem_letter_tag}
                <span class='os-divider'> </span>
                #{question.stimulus&.cut&.paste}
                #{question.stem&.cut&.paste}
              </div>
            HTML
          )

          question&.cut(to: questions_clipboard)

          # Bake solutions
          Kitchen::Directions::BakeInjectedExerciseSolution.v1(
            question: question,
            id: id,
            number: problem_letter,
            options: { solutions_clipboard: solutions_clipboard }
          )
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
