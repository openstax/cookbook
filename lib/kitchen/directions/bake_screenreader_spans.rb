# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeScreenreaderSpans
      # Add text for accessibility.
      # Additional screenreader spans can be added below.
      def self.v1(book:)
        book.search('u[data-effect="double-underline"]').each do |element|
          element.prepend(child:
            '<span data-screenreader-only="true">double underline</span>'
          )
          element.append(child:
            '<span data-screenreader-only="true">end double underline</span>'
          )
        end
        book.search('u[data-effect="underline"]').each do |element|
          element.prepend(child:
            '<span data-screenreader-only="true">underline</span>'
          )
          element.append(child:
            '<span data-screenreader-only="true">end underline</span>'
          )
        end
      end
    end
  end
end
