# frozen_string_literal: true

module Kitchen
  module Directions
    module EocSectionTitleLinkSnippet
      def self.v1(page:)
        chapter = page.ancestor(:chapter)
        <<~HTML
          <a href="##{page.title.id}">
            <h3 data-type="document-title" id="#{page.title.copied_id}">
              <span class="os-number">#{chapter.count_in(:book)}.#{page.count_in(:chapter)}</span>
              <span class="os-divider"> </span>
              <span class="os-text" data-type="" itemprop="">#{page.title_text}</span>
            </h3>
          </a>
        HTML
      end
    end
  end
end
