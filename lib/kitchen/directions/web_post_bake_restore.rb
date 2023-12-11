# frozen_string_literal: true

module Kitchen
  module Directions
    module WebPostBakeRestore
      def self.v1(book_pages:)
        pantry = book_pages.first.ancestor(:book).pantry(name: :web_placeholders)

        # Replace title & metadata elements, remove placeholders
        pantry.each do |replacement_key, element|
          placeholder_element = book_pages.search(
            "[data-replacement-key='#{replacement_key}']"
          ).first
          placeholder_element.append(sibling: element.to_s)
          placeholder_element.cut
        end
      end
    end
  end
end
