module Kitchen
  module Directions
    module BakeChapterKeyEquations
      def self.v1(chapter:, metadata_source:)
        metadata_elements = metadata_source.search(%w(.authors .publishers .print-style
                                                      .permissions [data-type='subject'])).copy

        chapter.key_equations.search('h3').trash
        key_equations = chapter.key_equations.cut

        return if key_equations.none?

        chapter.append(child:
          <<~HTML
            <div class="os-eoc os-key-equations-container" data-type="composite-page" data-uuid-key=".key-equations">
              <h2 data-type="document-title">
                <span class="os-text">#{I18n.t(:eoc_key_equations)}</span>
              </h2>
              <div data-type="metadata" style="display: none;">
                <h1 data-type="document-title" itemprop="name">#{I18n.t(:eoc_key_equations)}</h1>
                #{metadata_elements.paste}
              </div>
              #{key_equations.paste}
            </div>
          HTML
        )
      end
    end
  end
end
