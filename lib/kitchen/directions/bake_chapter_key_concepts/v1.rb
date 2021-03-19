# frozen_string_literal: true

module Kitchen::Directions::BakeChapterKeyConcepts
  class V1
    renderable
    def bake(chapter:, metadata_source:)
      @metadata_elements = metadata_source.children_to_keep.copy

      @key_concepts = []
      key_concepts_clipboard = Kitchen::Clipboard.new
      chapter.non_introduction_pages.each do |page|
        key_concepts = page.key_concepts
        next if key_concepts.none?

        key_concepts.search('h3').trash
        key_concepts.each do |key_concept|
          id = key_concept.id.split('fs-id')
          key_concept.prepend(child:
            <<~HTML
              <a href="##{id[0]}0">
                <h3 data-type="document-title" id="#{id[0]}0">
                  <span class="os-number">#{chapter.count_in(:book)}.#{page.count_in(:chapter)}</span>
                  <span class="os-divider"> </span>
                  <span class="os-text" data-type="" itemprop="">#{page.title.text}</span>
                </h3>
              </a>
            HTML
          )
          key_concept&.cut(to: key_concepts_clipboard)
        end
        @key_concepts.push(key_concepts_clipboard.paste)
      end

      chapter.append(child: render(file: 'key_concepts.xhtml.erb'))
    end
  end
end
