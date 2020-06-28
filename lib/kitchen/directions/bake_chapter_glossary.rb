module Kitchen
  module Directions
    module BakeChapterGlossary

      def self.v1(chapter:, metadata_source:)
        # TODO put the _copy_1 suffix on ID logic into `copy` as an option?
        metadata_elements = metadata_source.search(%w(.authors .publishers .print-style
                                                      .permissions [data-type='subject'])).copy

        definitions = chapter.glossaries.search("dl").cut
        definitions.sort_by!{|definition| definition.first("dt").text.downcase}

        chapter.glossaries.trash

        chapter.append(child:
          <<~HTML
            <div class="os-eoc os-glossary-container" data-type="composite-page" data-uuid-key="glossary">
              <h2 data-type="document-title">
                <span class="os-text">#{I18n.t(:key_terms)}</span>
              </h2>
              <div data-type="metadata" style="display: none;">
                <h1 data-type="document-title" itemprop="name">#{I18n.t(:key_terms)}</h1>
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
