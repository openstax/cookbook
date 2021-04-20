# frozen_string_literal: true

module Kitchen::Directions::BakeChapterKeyConcepts
  class V1
    renderable
    def bake(chapter:, metadata_source:, append_to:)
      @metadata_elements = metadata_source.children_to_keep.copy

      @key_concepts = []
      key_concepts_clipboard = Kitchen::Clipboard.new
      chapter.non_introduction_pages.each do |page|
        key_concepts = page.key_concepts
        next if key_concepts.none?

        key_concepts.search('h3').trash
        title = Kitchen::Directions::EocSectionTitleLinkSnippet.v1(page: page)
        key_concepts.each do |key_concept|
          key_concept.prepend(child: title)
          key_concept&.cut(to: key_concepts_clipboard)
        end
        @key_concepts.push(key_concepts_clipboard.paste)
        key_concepts_clipboard.clear
      end

      append_to_element = append_to || chapter

      append_to_element.append(child: render(file: 'key_concepts.xhtml.erb'))
    end
  end
end
