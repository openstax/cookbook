# frozen_string_literal: true

module Kitchen::Directions::BakeInjectedExerciseQuestion
  def self.v1(question:, number:, options: {
    only_number_solution: false,
    add_dot: false,
    problem_with_prefix: false,
    suppress_summary: false,
    suppress_detailed: false,
    answer_letter_upper: false,
    answer_letter_only: false,
    prioritize_solution: nil
  })
    options.reverse_merge!(
      only_number_solution: false,
      add_dot: false,
      problem_with_prefix: false,
      suppress_summary: false,
      suppress_detailed: false,
      answer_letter_upper: false,
      answer_letter_only: false,
      prioritize_solution: nil
    )

    V1.new.bake(question: question, number: number, options: options)
  end

  class V1
    def bake(question:, number:, options:)
      id = question.id
      in_appendix = question.has_ancestor?(:page) && question.ancestor(:page).has_class?('appendix')
      in_preface = question.has_ancestor?(:page) && question.ancestor(:page).has_class?('preface')
      alphabetical_multipart =
        question.search("div[data-type='alphabetical-question-multipart']")&.first&.present?

      # Store label in pantry
      unless options[:only_number_solution]
        label_number = if in_appendix || in_preface
                         "#{question.ancestor(:page).count_in(:book)}.#{number}"
                       else
                         "#{question.ancestor(:chapter).count_in(:book)}.#{number}"
                       end
        question.target_label(label_text: 'exercise', custom_content: label_number)
      end

      # Synthesize multiple choice solution
      if question.answers
        case question.answers[:type]
        when 'a'
          alphabet = if options[:answer_letter_upper]
                       [*('A'..'Z')]
                     else
                       [*('a'..'z')]
                     end
        else
          raise('Unsupported list type for multiple choice options')
        end
        letter_answers = question.correct_answer_letters(alphabet)
      end
      has_letter_answers = letter_answers.present?
      answer_letter_only = options[:answer_letter_only]
      if options[:suppress_summary] || (has_letter_answers && answer_letter_only)
        question.solutions('$[data-solution-type="summary"]').each(&:trash)
      end
      if options[:suppress_detailed] || (has_letter_answers && answer_letter_only)
        question.solutions('$[data-solution-type="detailed"]').each(&:trash)
      end
      if has_letter_answers
        text_content = "#{letter_answers.join(', ')}#{'.' if options[:add_dot]}"
        answer_letters_span = "<span class=\"answer-letters\">#{text_content}</span>"
        if !question.solution
          question.append(child:
            <<~HTML
              <div data-type="question-solution">
                #{answer_letters_span}
              </div>
            HTML
          )
        else
          question.solution.prepend(child: answer_letters_span)
        end
      end

      # Bake question
      unless options[:only_number_solution]
        if options[:problem_with_prefix]
          problem_number = <<~HTML
            <div class="os-prefix">
              <span class="os-label">#{I18n.t('problem')}</span>
              <span class="os-number">#{number}</span>
            </div>
          HTML
          if question.solution
            problem_number = <<~HTML
              <a class="os-prefix" href='##{id}-solution'>
                <span class="os-label">#{I18n.t('problem')}</span>
                <span class="os-number">#{number}</span>
              </a>
            HTML
          end
        else
          problem_number = <<~HTML
            <span class='os-number'>#{number}</span>
            <span class='os-divider'>. </span>
          HTML
          if question.solution
            problem_number = <<~HTML
              <a class='os-number' href='##{id}-solution'>#{number}</a><span class='os-divider'>. </span>
            HTML
          end
        end
      end

      context = question.exercise_context_in_question&.cut&.paste

      question.prepend(child:
        <<~HTML
          #{problem_number unless options[:only_number_solution]}
          <div class="os-problem-container">
            #{context if context.present?}#{"<span class='os-divider'>. </span>" if context.present?}
            #{question.stimulus&.cut&.paste}
            #{alphabetical_multipart ? question.search("div[data-type='alphabetical-question-multipart']").cut.paste : question.stem.cut.paste}
            #{question.answers&.cut&.paste}
          </div>
        HTML
      )

      # Bake solution
      Kitchen::Directions::BakeInjectedExerciseSolution.v1(
        question: question,
        id: id,
        number: number,
        options: {
          problem_with_prefix: options[:problem_with_prefix],
          suppress_summary: options[:suppress_summary],
          suppress_detailed: options[:suppress_detailed],
          prioritize_solution: options[:prioritize_solution]
        }
      )

      question.search('div[data-type="answer-feedback"]').each(&:trash)
    end
  end
end
