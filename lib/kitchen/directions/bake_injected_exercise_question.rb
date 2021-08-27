# frozen_string_literal: true

module Kitchen::Directions::BakeInjectedExerciseQuestion
  def self.v1(question:, number:, only_number_solution: false)
    V1.new.bake(question: question, number: number, only_number_solution: only_number_solution)
  end

  class V1
    def bake(question:, number:, only_number_solution:)
      id = question.id

      # Store label in pantry
      unless only_number_solution
        label_number = "#{question.ancestor(:chapter).count_in(:book)}.#{number}"
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
      if letter_answers.present?
        question.append(child:
          <<~HTML
            <div data-type="question-solution">#{letter_answers.join(', ')}</div>
          HTML
        )
      end

      # Bake question
      unless only_number_solution
        problem_number = "<span class='os-number'>#{number}</span>"
        if question.solution
          problem_number = "<a class='os-number' href='##{id}-solution'>#{number}</a>"
        end
      end

      question.prepend(child:
        <<~HTML
          #{problem_number unless only_number_solution}
          #{"<span class='os-divider'>. </span>" unless only_number_solution}
          <div class="os-problem-container">
            #{question.stimulus&.cut&.paste}
            #{question.stem.cut.paste}
            #{question.answers&.cut&.paste}
          </div>
        HTML
      )

      # Bake solution
      solution = question.solution
      return unless solution

      question.add_class('os-hasSolution')
      solution.id = "#{id}-solution"
      solution.replace_children(with:
        <<~HTML
          <a class='os-number' href='##{id}'>#{number}</a>
          <span class='os-divider'>. </span>
          <div class="os-solution-container">#{solution.children}</div>
        HTML
      )
    end
  end
end
