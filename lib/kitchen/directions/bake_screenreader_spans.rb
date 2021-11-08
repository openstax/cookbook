# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeScreenreaderSpans
      # Add text for accessibility.
      # Additional screenreader spans can be added below.
      def self.v1(book:)
        book.search('u[data-effect="double-underline"]').each do |element|
          element.add_previous_sibling(
            '<span data-screenreader-only="true">double underline</span>'
          )
        end
        book.search('u[data-effect="underline"]').each do |element|
          element.add_previous_sibling(
            '<span data-screenreader-only="true">underline</span>'
          )
        end
      end
    end
  end
end
