# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeAllChapterSolutionsTypes
      def self.v1(chapter:, within:, metadata_source:, uuid_prefix: '')
        solutions_clipboard = Kitchen::Clipboard.new

        within.search_with(ExerciseElementEnumerator, InjectedQuestionElementEnumerator)\
              .each do |exercise|

          solution = exercise.solution
          next unless solution.present?

          solution.cut(to: solutions_clipboard)
        end

        content = solutions_clipboard.paste

        Kitchen::Directions::CompositePageContainer.v1(
          container_key: 'solutions',
          uuid_key: "#{uuid_prefix}solutions",
          metadata_source: metadata_source,
          content: content,
          append_to: chapter
        )
      end
    end
  end
end
