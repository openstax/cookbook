# frozen_string_literal: true

module Kitchen
  module Directions
    module EocSectionTitleLinkSnippet
      def self.v1(page:, title_tag: 'h3', wrapper: 'link')
        chapter = page.ancestor(:chapter)

        title_snippet = <<~HTML
          <#{title_tag} data-type="document-title" id="#{page.title.copied_id}">
            <span class="os-number">#{chapter.count_in(:book)}.#{page.count_in(:chapter)}</span>
            <span class="os-divider"> </span>
            <span class="os-text" data-type="" itemprop="">#{page.title_text}</span>
          </#{title_tag}>
        HTML

        case wrapper
        when 'link'
          <<~HTML
            <a href="##{page.title.id}">
              #{title_snippet}
            </a>
          HTML
        when 'div'
          <<~HTML
            <div>
              #{title_snippet}
            </div>
          HTML
        else
          title_snippet
        end
      end
    end
  end
end
