# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeAccessibilityFixes
      def self.v1(section:)
        section.search('ol[data-number-style="lower-alpha"]').each { |ol| ol['type'] = 'a' }
      end
    end
  end
end
