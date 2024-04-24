# frozen_string_literal: true

module Kitchen::Directions::BakeInjectedExerciseQuestion
  def self.v1(question:, number:, options: {
    only_number_solution: false,
    add_dot: false,
    problem_with_prefix: false
  })
    options.reverse_merge!(
      only_number_solution: false,
      add_dot: false,
      problem_with_prefix: false
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
          alphabet = *('a'..'z')
        else
          raise('Unsupported list type for multiple choice options')
        end
        letter_answers = question.correct_answer_letters(alphabet)
      end
      if letter_answers.present? && !question.solution
        question.append(child:
          <<~HTML
            <div data-type="question-solution">
              #{letter_answers.join(', ')}#{'.' if options[:add_dot]}
            </div>
          HTML
        )
      elsif letter_answers.present?
        question.solution.prepend(child:
          "<span>#{letter_answers.join(', ')}#{'.' if options[:add_dot]}</span>")
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
      solutions_count = question.solutions.count
      return unless solutions_count != 0

      question.add_class('os-hasSolution')

      solution_number = if options[:problem_with_prefix]
                          <<~HTML
                            <a class="os-prefix" href='##{id}'>
                              <span class="os-label">#{I18n.t('problem')}</span>
                              <span class="os-number">#{number}</span>
                            </a>
                          HTML
                        else
                          <<~HTML
                            <a class='os-number' href='##{id}'>#{number}</a><span class='os-divider'>. </span>
                          HTML
                        end

      if solutions_count == 1
        solution = question.solution
        solution.id = "#{id}-solution"
        solution.replace_children(with:
          <<~HTML
            #{solution_number}<div class="os-solution-container">#{solution.children}</div>
          HTML
        )
      elsif solutions_count > 1
        solutions_clipboard = Kitchen::Clipboard.new

        question.solutions.each do |question_solution|
          partial_solution =
            <<~HTML
              <div class="os-partial-solution">#{question_solution.children}</div>
            HTML

          question_solution.replace_children(with: partial_solution)

          question.search('.os-partial-solution').first.cut(to: solutions_clipboard)

          question_solution.trash
        end

        question.append(child:
          <<~HTML
            <div data-type='question-solution' id='#{id}-solution'>
              #{solution_number}
              <div class="os-solution-container">
                #{solutions_clipboard.paste}
              </div>
            </div>
          HTML
        )
      end

      question.search('div[data-type="answer-feedback"]').each(&:trash)
    end
  end
end
