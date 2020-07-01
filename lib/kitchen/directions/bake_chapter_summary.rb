module Kitchen
  module Directions
    module BakeChapterSummary

      def self.v1(chapter:, metadata_source:)
        metadata_elements = metadata_source.search(%w(.authors .publishers .print-style
                                                      .permissions [data-type='subject'])).copy

        summaries = Clipboard.new
        chapter.pages.each do |page|
          next if page.is_introduction?

          summary = page.summary
          summary.first("h3").trash # get rid of old title
          summary_title = page.title.clone
          summary_title.name = "h3"
          summary.prepend(child:
            <<~HTML
              <a href="##{page.title.id}">
                #{summary_title}
              </a>
            HTML
          )
          summary.cut(to: summaries)
        end

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
