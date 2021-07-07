# frozen_string_literal: true

module Kitchen
  module Directions
    module RemoveSectionTitle
      def self.v1(section:)
        section.first('[data-type="title"]')&.trash
      end
    end
  end
end
