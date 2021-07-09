# frozen_string_literal: true

module Kitchen::Directions::MoveExercisesToEOC
  # The difference from v1 is the presence of a section title
  # and from v2 the lack of additional "os-section-area" and os-#{@klass} wrappers
  class V3
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
        title = Kitchen::Directions::EocSectionTitleLinkSnippet.v1(
          page: exercise_section.ancestor(:page)
        )
        exercise_section.prepend(child: title)
      end
    end
  end
end
