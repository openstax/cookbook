# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeAppendixFeatureTitles
      def self.v1(section:, selector:)
        V1.new.bake(section: section, selector: selector)
      end
    end
  end
end
