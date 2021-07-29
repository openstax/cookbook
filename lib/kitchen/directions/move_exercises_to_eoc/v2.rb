# frozen_string_literal: true

module Kitchen::Directions::MoveExercisesToEOC
  # Main difference from v1 is the presence of a section title
  # and some additional wrappers
  class V2
    def bake(chapter:, metadata_source:, klass:, append_to: nil, uuid_prefix: '.')
      Kitchen::Directions::MoveCustomSectionToEocContainer.v1(
        chapter: chapter,
        metadata_source: metadata_source,
        container_key: klass,
        uuid_key: "#{uuid_prefix}#{klass}",
        section_selector: "section.#{klass}",
        append_to: append_to || chapter,
        include_intro_page: false,
        wrap_section: true, wrap_content: true
      ) do |section|
        Kitchen::Directions::RemoveSectionTitle.v1(section: section)
        title = Kitchen::Directions::EocSectionTitleLinkSnippet.v1(page: section.ancestor(:page))
        section.prepend(child: title)
      end
    end
  end
end
