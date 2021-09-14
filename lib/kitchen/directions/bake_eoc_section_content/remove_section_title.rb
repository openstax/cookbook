# frozen_string_literal: true

module Kitchen
  module Directions
    module RemoveSectionTitle
      def self.v1(section:, selector: '')
        section.first("#{selector}[data-type=\"title\"]")&.trash
      end
    end
  end
end
