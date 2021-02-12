# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for eoc summary
    #
    module BakeChapterSummary
      def self.v1(chapter:, metadata_source:)
        metadata_elements = metadata_source.children_to_keep.copy

        summaries = Clipboard.new

        # TODO: include specific page types somehow without writing it out
        chapter.pages('$:not(.introduction)').each do |page|
          summary = page.summary
          summary.first("[data-type='title']").trash # get rid of old title
          summary_title = page.title.copy
          summary_title.name = 'h3'
          summary_title.replace_children(with: <<~HTML
            <span class="os-number">#{chapter.count_in(:book)}.#{page.count_in(:chapter)}</span>
            <span class="os-divider"> </span>
            <span class="os-text" data-type="" itemprop="">#{summary_title.children}</span>
          HTML
          )

          summary.prepend(child:
            <<~HTML
              <a href="##{page.title.id}">
                #{summary_title.paste}
              </a>
            HTML
          )
          summary.cut(to: summaries)
        end

        return if summaries.none?

        chapter.append(child:
          <<~HTML
            <div class="os-eoc os-summary-container" data-type="composite-page" data-uuid-key=".summary">
              <h2 data-type="document-title">
                <span class="os-text">#{I18n.t(:eoc_summary_title)}</span>
              </h2>
              <div data-type="metadata" style="display: none;">
                <h1 data-type="document-title" itemprop="name">#{I18n.t(:eoc_summary_title)}</h1>
                #{metadata_elements.paste}
              </div>
              #{summaries.paste}
            </div>
          HTML
        )
      end
    end
  end
end
