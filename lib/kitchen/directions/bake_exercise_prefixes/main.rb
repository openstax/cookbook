# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeExercisePrefixes
      def self.v1(chapter:, sections_prefixed:)
        V1.new.bake(
          chapter: chapter,
          sections_prefixed: sections_prefixed
        )
      end
    end
  end
end
