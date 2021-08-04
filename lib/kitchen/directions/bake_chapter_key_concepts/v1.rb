# frozen_string_literal: true

module Kitchen::Directions::BakeChapterKeyConcepts
  class V1
    def bake(chapter:, metadata_source:, append_to:, uuid_prefix:)
      Kitchen::Directions::MoveCustomSectionToEocContainer.v1(
        chapter: chapter,
        metadata_source: metadata_source,
        container_key: 'key-concepts',
        uuid_key: "#{uuid_prefix}key-concepts",
        section_selector: 'section.key-concepts',
        append_to: append_to || chapter,
        wrap_section: true, wrap_content: true
      ) do |section|
        Kitchen::Directions::RemoveSectionTitle.v1(section: section)
        title = Kitchen::Directions::EocSectionTitleLinkSnippet.v1(page: section.ancestor(:page))
        section.prepend(child: title)
      end
    end
  end
end
