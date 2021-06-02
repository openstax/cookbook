# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeChapterIntroductions
      def self.v1(book:, bake_chapter_objectives: true)
        book.chapters.each do |chapter|
          chapter_outline_html = ''

          if bake_chapter_objectives
            outline_items_html = chapter.non_introduction_pages.map do |page|

              <<~HTML
                <div class="os-chapter-objective">
                  <a class="os-chapter-objective" href="##{page.title[:id]}">
                    <span class="os-number">#{chapter.count_in(:book)}.#{page.count_in(:chapter)}</span>
                    <span class="os-divider"> </span>
                    <span data-type="" itemprop="" class="os-text">#{page.title.children[0].text}</span>
                  </a>
                </div>
              HTML
            end.join('')

            chapter_outline_html = <<~HTML
              <div class="os-chapter-outline">
                <h3 class="os-title">#{I18n.t(:chapter_outline)}</h3>
                #{outline_items_html}
              </div>
            HTML
          end

          introduction_page = chapter.introduction_page

          introduction_page.search("div[data-type='description']").trash
          introduction_page.search("div[data-type='abstract']").trash

          title = introduction_page.title.cut
          title.name = 'h2'
          MoveTitleTextIntoSpan.v1(title: title)

          intro_content = introduction_page.search("> :not([data-type='metadata']):not(.splash):not(.has-splash)").cut

          introduction_page.append(child:
            <<~HTML
              <div class="intro-body">
                #{chapter_outline_html}
                <div class="intro-text">
                  #{title.paste}
                  #{intro_content.paste}
                </div>
              </div>
            HTML
          )
        end

        v1_update_selectors(book)
      end

      def self.v1_update_selectors(something_with_selectors)
        something_with_selectors.selectors.title_in_introduction_page =
          ".intro-text > [data-type='document-title']"
      end
    end
  end
end
