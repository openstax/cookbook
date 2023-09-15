# frozen_string_literal: true

module Kitchen::Directions::BakeReferences
  class V4
    def bake(book:, metadata_source:, cases: false)
      book.chapters.each do |chapter|

        chapter.references.search('h3').trash

        chapter_references = chapter.pages.references.cut
        chapter_title_text = chapter.title.search('.os-text')
        introduction_page = chapter.introduction_page

        next if chapter_references.items.empty?

        chapter.append(child:
          <<~HTML
            <div class="os-chapter-area">
              <a href="##{introduction_page.id}_titlecreatedbycookbook">
                <h2 data-type="document-title" data-rex-keep="true">
                  <span class="os-part-text">#{I18n.t("chapter#{'.nominative' if cases}")} </span>
                  <span class="os-number">#{chapter.count_in(:book)}</span>
                  <span class="os-divider"> </span>
                  #{chapter_title_text}
                </h2>
              </a>
              #{chapter_references.paste}
            </div>
          HTML
        )
      end

      chapter_area_references = book.chapters.search('.os-chapter-area').cut

      Kitchen::Directions::CompositePageContainer.v1(
        container_key: 'references',
        uuid_key: '.references',
        metadata_source: metadata_source,
        content: chapter_area_references.paste,
        append_to: book.body
      )
    end
  end
end
