# frozen_string_literal: true

module Kitchen::Directions::MoveExercisesToEOC
  class V1
    def bake(chapter:, metadata_source:, klass:, append_to: nil, uuid_prefix: '.')
      Kitchen::Directions::MoveCustomSectionToEocContainer.v1(
        chapter: chapter,
        metadata_source: metadata_source,
        container_key: klass,
        uuid_key: "#{uuid_prefix}#{klass}",
        section_selector: "section.#{klass}",
        append_to: append_to || chapter,
        include_intro_page: false
      ) do |exercise_section|
        Kitchen::Directions::RemoveSectionTitle.v1(section: exercise_section)
      end
    end
  end
end
