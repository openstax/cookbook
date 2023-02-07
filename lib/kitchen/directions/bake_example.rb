# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeExample
      def self.v1(example:, number:, title_tag:, options: {
        # numbered_solutions: false, # It's not used anymore, left just in case we gonna need this in next edition
        cases: false,
        add_problem_title: false
      })
        options.reverse_merge!(
          # numbered_solutions: false,
          cases: false,
          add_problem_title: false
        )

        example.wrap_children(class: 'body')

        example.prepend(child:
          <<~HTML
            <#{title_tag} class="os-title">
              <span class="os-title-label">#{I18n.t("example#{options[:cases] ? '.nominative' : ''}")} </span>
              <span class="os-number">#{number}</span>
              <span class="os-divider"> </span>
            </#{title_tag}>
          HTML
        )

        # Store label information
        example.target_label(label_text: 'example', custom_content: number, cases: options[:cases])

        example.titles_to_rename.each do |title|
          title.name = 'h4'
        end

        example.exercises.each do |exercise|
          next if exercise.baked?

          if (problem = exercise.problem)
            problem.wrap_children(class: 'os-problem-container')
            if options[:add_problem_title]
              problem.prepend(child:
                <<~HTML
                  <h4 data-type="problem-title">
                    <span class="os-title-label">#{I18n.t(:problem)}</span>
                  </h4>
                HTML
              )
            end
          end

          exercise.solutions.each do |solution|
            # It's not used anymore, left just in case we gonna need this in next edition
            #
            # solution_number = if options[:numbered_solutions]
            #                     "<span class=\"os-number\">#{solution.count_in(:example)}</span>"
            #                   else
            #                     ''
            #                   end
            solution.replace_children(with:
              <<~HTML
                <h4 data-type="solution-title">
                  <span class="os-title-label">#{I18n.t(:solution)}</span>
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
