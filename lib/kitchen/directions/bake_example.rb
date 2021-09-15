# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeExample
      def self.v1(example:, number:, title_tag:, numbered_solutions: false, cases: false)
        example.wrap_children(class: 'body')

        example.prepend(child:
          <<~HTML
            <#{title_tag} class="os-title">
              <span class="os-title-label">#{I18n.t("example#{'.nominative' if cases}")} </span>
              <span class="os-number">#{number}</span>
              <span class="os-divider"> </span>
            </#{title_tag}>
          HTML
        )

        # Store label information
        example.target_label(label_text: 'example', custom_content: number, cases: cases)

        example.titles_to_rename.each do |title|
          title.name = 'h4'
        end

        example.exercises.each do |exercise|
          next if exercise.baked?

          if (problem = exercise.problem)
            problem.wrap_children(class: 'os-problem-container')
          end

          exercise.solutions.each do |solution|
            solution_number = if numbered_solutions
                                "<span class=\"os-number\">#{solution.count_in(:example)}</span>"
                              else
                                ''
                              end
            solution.replace_children(with:
              <<~HTML
                <h4 data-type="solution-title">
                  <span class="os-title-label">#{I18n.t(:solution)} </span>
                  #{solution_number}
                </h4>
                <div class="os-solution-container">#{solution.children}</div>
              HTML
            )
          end

          exercise.add_class('unnumbered')

          commentary = exercise.first('div[data-type="commentary"]')
          next unless commentary.present?

          commentary_title = commentary.titles.first
          next unless commentary_title.present? && commentary_title.parent['data-type'] != 'list'

          commentary_title.name = 'h4'
          commentary_title['data-type'] = 'commentary-title'
          commentary_title.wrap_children('span', class: 'os-title-label')
        end
      end
    end
  end
end
