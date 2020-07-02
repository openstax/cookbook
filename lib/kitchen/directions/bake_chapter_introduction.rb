module Kitchen
  module Directions
    module BakeChapterIntroduction

      def self.v1(chapter:)
        outline_items_html = chapter.pages.map do |page|
          next if page.is_introduction?

          <<~HTML
            <div class="os-chapter-objective">
              <a class="os-chapter-objective" href="##{page.title[:id]}">
                <span class="os-number">#{chapter.count_in(:book)}.#{page.count_in(:chapter)-1}</span>
                <span class="os-divider"> </span>
                <span data-type="" itemprop="" class="os-text">#{page.title.children[0].text}</span>
              </a>
            </div>
          HTML
        end.join("")

        introduction_page = chapter.introduction_page # chapter.pages("$.introduction").first

        introduction_page.search("div[data-type='description']").trash
        introduction_page.search("div[data-type='abstract']").trash

        title = introduction_page.title.cut
        title.name = "h2"
        MoveTitleTextIntoSpan.v1(title: title)

        intro_content = introduction_page.search("> :not([data-type='metadata']):not(figure)").cut

        introduction_page.append(child:
          <<~HTML
            <div class="intro-body">
              <div class="os-chapter-outline">
                <h3 class="os-title">Chapter Outline</h3>
                #{outline_items_html}
              </div>
              <div class="intro-text">
                #{title.paste}
                #{intro_content.paste}
              </div>
            </div>
          HTML
        )
      end

    end
  end
end
