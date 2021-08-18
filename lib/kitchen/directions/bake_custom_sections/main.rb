# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeCustomSections
      def self.v1(chapter:, custom_sections_properties:)
        V1.new.bake(
          chapter: chapter,
          custom_sections_properties: custom_sections_properties
        )
      end
    end
  end
end
