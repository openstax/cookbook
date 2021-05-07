# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for EOC suggested reading
    #
    module BakeSuggestedReading
      def self.v1(book:)
        metadata_elements = book.metadata.children_to_keep.copy
        book.chapters.each do |chapter|
          suggested_reading = chapter.search('section.suggested-reading').cut

          chapter.append(child:
            <<~HTML
              <div class="os-eoc os-suggested-reading-container" data-type="composite-page" data-uuid-key=".suggested-reading">
                <div data-type="metadata" style="display: none;">
                  <h1 data-type="document-title" itemprop="name">#{I18n.t(:eoc_suggested_reading)}</h1>
                  #{metadata_elements.paste}
                </div>
                <h2 data-type="document-title">
                  <span class="os-text">#{I18n.t(:eoc_suggested_reading)}</span>
                </h2>
                #{suggested_reading.paste}
              </div>
            HTML
          )
        end
      end
    end
  end
end
