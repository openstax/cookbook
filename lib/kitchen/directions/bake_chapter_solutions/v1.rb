# frozen_string_literal: true

module Kitchen::Directions::BakeChapterSolutions
  class V1
    def bake(chapter:, metadata_source:, uuid_prefix: '')
      solutions_clipboard = Kitchen::Clipboard.new

      chapter.search('section.free-response').each do |free_response_question|
        exercises = free_response_question.exercises
        # must run AFTER .free-response notes are baked

        next if exercises.none?

        exercises.each do |exercise|
          solution = exercise.solution
          next unless solution.present?

          solution.cut(to: solutions_clipboard)
        end
      end

      content = solutions_clipboard.paste

      Kitchen::Directions::EocCompositePageContainer.v1(
        container_key: 'solutions',
        uuid_key: "#{uuid_prefix}solutions",
        metadata_source: metadata_source,
        content: content,
        append_to: chapter
      )
    end
  end
end
