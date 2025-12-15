# frozen_string_literal: true

module Kitchen::Directions::BakeReferences
  class V1
    renderable

    def bake(book:, metadata_source:, numbered_title:)
      book.chapters.each do |chapter|
        chapter.search('[data-type="cite"]').each do |link|
          reference_number = link.count_in(:chapter)
          link.prepend(child:
            <<~HTML.chomp
              <sup class="os-citation-number">#{reference_number}</sup>
            HTML
          )

          next if link.nil?

          link_sibling = link.previous unless link.preceded_by_text?
          next if link_sibling.nil?

          next unless link_sibling&.raw&.attr('data-type') == 'cite'
          link_description = I18n.t(:reference_link_desc, reference: reference_number)
          link[:'aria-label'] = link_description

          link.prepend(sibling:
            <<~HTML.strip.chomp
              <span class="os-reference-link-separator"><sup>, </sup></span>
            HTML
          )
        end

        chapter.references.each do |reference|
          reference.prepend(child:
            <<~HTML.chomp
              <span class="os-reference-number">#{reference.count_in(:chapter)}. </span>
            HTML
          )
        end

        chapter_references = chapter.pages.references.cut

        chapter_title = if numbered_title
                          chapter.title.search('.os-number, .os-divider, .os-text')
                        else
                          chapter.title.search('.os-text')
                        end

        chapter.append(child:
          <<~HTML
            <div class="os-chapter-area">
              <h2 data-type="document-title" data-rex-keep="true">#{chapter_title}</h2>
              #{chapter_references.paste}
            </div>
          HTML
        )
      end

      chapter_area_references = book.chapters.search('.os-chapter-area').cut

      Kitchen::Directions::CompositePageContainer.v1(
        container_key: 'reference',
        uuid_key: '.reference',
        metadata_source: metadata_source,
        content: chapter_area_references.paste,
        append_to: book.body
      )
    end
  end
end
