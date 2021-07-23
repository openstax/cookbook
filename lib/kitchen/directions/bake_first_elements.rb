# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeFirstElements
      def self.v1(within:)
        # add has-first-element class
        selectors = [
          'div.os-problem-container > div.os-table',
          'div.os-problem-container > span[data-type="media"]',
          'div.os-solution-container > div.os-table',
          'div.os-solution-container > span[data-type="media"]'
        ]
        selectors.each do |selector|
          within.search("#{selector}:first-child").each do |problem|
            problem.add_class('first-element')
            problem.parent.add_class('has-first-element')
          end
        end

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
