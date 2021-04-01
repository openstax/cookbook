# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for eoc key equations
    #
    module BakeChapterKeyEquations
      def self.v1(chapter:, metadata_source:, append_to: nil)
        metadata_elements = metadata_source.children_to_keep.copy

        chapter.key_equations.search('h3').trash
        key_equations = chapter.key_equations.cut

        return if key_equations.none?

        append_to_element = append_to || chapter

        append_to_element.append(child:
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
