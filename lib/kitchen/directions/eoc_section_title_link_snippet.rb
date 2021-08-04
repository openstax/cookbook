# frozen_string_literal: true

module Kitchen
  module Directions
    module EocSectionTitleLinkSnippet
      def self.v1(page:, title_tag: 'h3', wrapper: 'link')
        if page.is_introduction?
          os_number = ''
        else
          chapter = page.ancestor(:chapter)
          os_number =
            <<~HTML
              <span class="os-number">#{chapter.count_in(:book)}.#{page.count_in_chapter_without_intro_page}</span>
              <span class="os-divider"> </span>
            HTML
        end

        title_snippet = <<~HTML
          <#{title_tag} data-type="document-title" id="#{page.title.copied_id}">
            #{os_number}
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
