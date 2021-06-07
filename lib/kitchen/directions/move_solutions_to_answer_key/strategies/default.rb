# frozen_string_literal: true

module Kitchen::Directions::MoveSolutionsToAnswerKey
  module Strategies
    class Default
      def bake(chapter:, append_to:)
        bake_section(chapter: chapter, append_to: append_to)
      end

      protected

      def bake_section(chapter:, append_to:)
        @classes.each do |klass|
          chapter.search(".#{klass} [data-type='solution']").each do |solution|
            append_to.add_child(solution.cut.to_s)
          end
        end
      end

      # This method helps to obtain more strategy-specific params through
      # "strategy_options: {blah1: 1, blah2: 2}"
      def initialize(strategy_options)
        @classes = strategy_options[:classes] || (raise 'missing classes for strategy')
      end
    end
  end
end
