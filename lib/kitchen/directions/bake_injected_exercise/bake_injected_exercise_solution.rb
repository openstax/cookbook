# frozen_string_literal: true

module Kitchen::Directions::BakeInjectedExerciseSolution
  def self.v1(question:, id:, number:, options: {
    problem_with_prefix: false,
    solutions_clipboard: nil,
    suppress_summary: false
  })
    options.reverse_merge!(
      problem_with_prefix: false,
      solutions_clipboard: nil,
      suppress_summary: false,
      suppress_detailed: false
    )

    V1.new.bake(question: question, id: id, number: number, options: options)
  end

  class V1
    def bake(question:, id:, number:, options:)
      # Suppress summary solution before counting solutions
      if options[:suppress_summary]
        question.solutions('$[data-solution-type="summary"]').each(&:trash)
      end
      if options[:suppress_detailed]
        question.solutions('$[data-solution-type="detailed"]').each(&:trash)
      end

      # Count solutions
      solutions_count = question.solutions.count
      return unless solutions_count != 0

      question.add_class('os-hasSolution') unless options[:solutions_clipboard]

      solution_number = solution_number(id: id, number: number, options: options)

      if solutions_count == 1
        solution = question.solution
        solution.id = "#{id}-solution"

        solution.replace_children(with:
          <<~HTML
            #{solution_number}<div class="os-solution-container">#{solution.children}</div>
          HTML
        )

        if options[:solutions_clipboard]
          solution.set(:'data-type', 'solution-part')
          solution.cut(to: options[:solutions_clipboard])
        end
      elsif solutions_count > 1
        partial_solutions_clipboard = Kitchen::Clipboard.new

        question.solutions.each do |question_solution|
          partial_solution =
            <<~HTML
              <div class="os-partial-solution">#{question_solution.children}</div>
            HTML

          question_solution.replace_children(with: partial_solution)

          question.search('.os-partial-solution').first.cut(to: partial_solutions_clipboard)

          question_solution.trash
        end

        selector = options[:solutions_clipboard] ? 'solution-part' : 'question-solution'

        question.append(child:
          <<~HTML
            <div data-type="#{selector}" id="#{id}-solution">
              #{solution_number}
              <div class="os-solution-container">#{partial_solutions_clipboard.paste}</div>
            </div>
          HTML
        )

        if options[:solutions_clipboard]
          solution = question.search('[data-type="solution-part"]').first
          solution.cut(to: options[:solutions_clipboard])
        end
      end
    end

    def solution_number(id:, number:, options:)
      if options[:problem_with_prefix]
        <<~HTML
          <a class="os-prefix" href='##{id}'>
            <span class="os-label">#{I18n.t('problem')}</span>
            <span class="os-number">#{number}</span>
          </a>
        HTML
      elsif options[:solutions_clipboard]
        <<~HTML
          <a class='problem-letter' href='##{id}'>#{number}</a><span class='os-divider'> </span>
        HTML
      else
        <<~HTML
          <a class='os-number' href='##{id}'>#{number}</a><span class='os-divider'>. </span>
        HTML
      end
    end
  end
end
