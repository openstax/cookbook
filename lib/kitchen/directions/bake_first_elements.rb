# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeFirstElements
      def self.v1(within:, selectors:)
        selectors.each do |selector|
          within.search("#{selector}:first-child").each do |problem|
            problem.add_class('first-element')
            problem.parent.add_class('has-first-element')
          end
        end
      end
    end
  end
end
