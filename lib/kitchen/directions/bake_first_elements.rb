# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeFirstElements
      def self.v1(within:, first_inline_list: false)
        # add has-first-element class
        selectors = [
          'div.os-problem-container > div.os-table',
          'div.os-problem-container > span[data-type="media"]',
          'div.os-problem-container > div.os-figure',
          'div[data-type="alphabetical-question-multipart"] div[data-type="question-stem"] > img',
          'div.os-solution-container > div.os-table',
          'div.os-solution-container > span[data-type="media"]',
          'div.os-solution-container > div.os-figure',
          'div.os-solution-container > img'
        ]
        selectors.each do |selector|
          within.search("#{selector}:first-child").each do |problem|
            problem.add_class('first-element')
            problem.parent.add_class('has-first-element')
          end
        end

        third_level_selectors = [
          'div.os-problem-container > div[data-type="question-stimulus"]:first-child > img',
          'div.os-problem-container > div[data-type="question-stem"]:first-child > img'
        ]

        third_level_selectors.each do |third_level_selector|
          within.search("#{third_level_selector}:first-child").each do |problem|
            problem.add_class('first-element')
            problem.parent.parent.add_class('has-first-element')
          end
        end

        return unless first_inline_list

        # add first-inline-element class
        inline_selector = 'div.os-solution-container > ol[type="1"]:first-child,' \
                          'div.os-problem-container > ol[type="1"]:first-child'
        within.search(inline_selector).each do |inline_list|
          inline_list.add_class('first-inline-list-element')
          inline_list.parent.add_class('has-first-inline-list-element')
        end
      end
    end
  end
end
