# frozen_string_literal: true

module Kitchen::Directions::BakeChapterKeyConcepts
  class V1
    def bake(chapter:, metadata_source:, append_to:, uuid_prefix:)
      key_concepts_clipboard = Kitchen::Clipboard.new
      chapter.non_introduction_pages.each do |page|
        key_concepts = page.key_concepts
        next if key_concepts.none?

        title = Kitchen::Directions::EocSectionTitleLinkSnippet.v1(page: page)
        key_concepts.each do |key_concept|
          Kitchen::Directions::RemoveSectionTitle.v1(section: key_concept)
          key_concept.prepend(child: title)
          key_concept.wrap("<div class='os-section-area'>")
          page.search('div.os-section-area').first.cut(to: key_concepts_clipboard)
        end
      end

      content = "<div class=\"os-key-concepts\"> #{key_concepts_clipboard.paste} </div>"

      Kitchen::Directions::EocCompositePageContainer.v1(
        container_key: 'key-concepts',
        uuid_key: "#{uuid_prefix}key-concepts",
        metadata_source: metadata_source,
        content: content,
        append_to: append_to || chapter
      )
    end
  end
end
