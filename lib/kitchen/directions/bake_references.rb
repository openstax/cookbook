# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for EOB references
    #
    module BakeReferences
      def self.v1(book:)
        metadata_elements = book.metadata.children_to_keep.copy

        book.chapters.each do |chapter|
          chapter.search('[data-type="cite"]').each do |link|
            link.prepend(child:
              <<~HTML
                <sup>#{link.count_in(:chapter)}</sup>
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
          chapter_title_no_num = chapter.title.search('.os-text')

          chapter.append(child:
            <<~HTML
              <div class="os-chapter-area">
                <h2 data-type="document-title">#{chapter_title_no_num}</h2>
                #{chapter_references.paste}
              </div>
            HTML
          )
        end

        chapter_area_references = book.chapters.search('.os-chapter-area').cut

        book.body.append(child:
          <<~HTML
            <div class="os-eob os-reference-container" data-type="composite-page" data-uuid-key=".reference">
              <h1 data-type="document-title">
                <span class="os-text">#{I18n.t(:references)}</span>
              </h1>
              <div data-type="metadata" style="display: none;">
                <h1 data-type="document-title" itemprop="name">#{I18n.t(:references)}</h1>
                #{metadata_elements.paste}
              </div>
              #{chapter_area_references.paste}
            </div>
          HTML
        )
      end
    end
  end
end
