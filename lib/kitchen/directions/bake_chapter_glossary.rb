module Kitchen
  module Directions
    module BakeChapterGlossary
      def self.v1(chapter:, metadata_source:)
        metadata_elements = metadata_source.search(%w(.authors .publishers .print-style
                                                      .permissions [data-type='subject'])).copy

        definitions = chapter.glossaries.search('dl').cut
        definitions.sort_by! do |definition|
          [definition.first('dt').text.downcase, definition.first('dd').text.downcase]
        end

        chapter.glossaries.trash

        return if definitions.none?

        chapter.append(child:
          <<~HTML
            <div class="os-eoc os-glossary-container" data-type="composite-page" data-uuid-key="glossary">
              <h2 data-type="document-title">
                <span class="os-text">#{I18n.t(:eoc_key_terms_title)}</span>
              </h2>
              <div data-type="metadata" style="display: none;">
                <h1 data-type="document-title" itemprop="name">#{I18n.t(:eoc_key_terms_title)}</h1>
                #{metadata_elements.paste}
              </div>
              #{definitions.paste}
            </div>
          HTML
        )
      end
    end
  end
end
