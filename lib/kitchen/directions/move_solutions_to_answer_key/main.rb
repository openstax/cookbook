# frozen_string_literal: true

module Kitchen
  module Directions
    module MoveSolutionsToAnswerKey
      def self.v1(chapter:, metadata_source:, strategy:, append_to:, strategy_options: {}, solutions_plural: true)
        V1.new.bake(
          chapter: chapter,
          metadata_source: metadata_source,
          strategy: strategy,
          append_to: append_to,
          strategy_options: strategy_options,
          solutions_plural: solutions_plural
        )
      end
    end
  end
end
