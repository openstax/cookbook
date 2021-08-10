# frozen_string_literal: true

module Kitchen::Directions::MoveSolutionsToAnswerKey
  module Strategies
    class ContemporaryMath
      def bake(chapter:, append_to:)
        # Hacky numbering fix
        chapter.notes('$.your-turn').exercises.each do |exercise|
          solution = exercise.solution
          next unless solution

          number = exercise.ancestor(:note).count_in(:chapter)
          solution.first('a.os-number').inner_html = number.to_s
          solution.first('span.os-divider').inner_html = '. '
        end

        Kitchen::Directions::MoveSolutionsFromNumberedNote.v1(
          chapter: chapter, append_to: append_to, note_class: 'your-turn'
        )
      end
    end
  end
end
