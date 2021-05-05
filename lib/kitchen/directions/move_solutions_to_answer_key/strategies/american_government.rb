# frozen_string_literal: true

module Kitchen::Directions::MoveSolutionsToAnswerKey
  module Strategies
    class AmericanGovernment
      def bake(chapter:, append_to:)
        bake_section(chapter: chapter, append_to: append_to, klass: 'review-questions')
      end

      protected

      def bake_section(chapter:, append_to:, klass:)
        chapter.search(".#{klass} [data-type='solution']").each do |solution|
          append_to.add_child(solution.cut.to_s)
        end
      end
    end
  end
end
