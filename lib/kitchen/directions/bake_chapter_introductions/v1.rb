# frozen_string_literal: true

module Kitchen::Directions::BakeChapterIntroductions
  class V1
    # <b>DEPRECATED:</b> Please use <tt>v2</tt> instead.
    warn '[DEPRECATION] `v1` is deprecated.  Please use `v2` instead.'

    def bake(book:)
      book.chapters.each do |chapter|
        introduction_page = chapter.introduction_page

        introduction_page.search("div[data-type='description']").trash
        introduction_page.search("div[data-type='abstract']").trash

        title = introduction_page.title.cut
        title.name = 'h2'
        Kitchen::Directions::MoveTitleTextIntoSpan.v1(title: title)

        intro_content = introduction_page.search(
          "> :not([data-type='metadata']):not(.splash):not(.has-splash)"
        ).cut

        chapter_objectives_html = chapter.non_introduction_pages.map do |page|
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

        chapter_outline =
          Kitchen::Directions::BakeChapterIntroductions.bake_chapter_outline(
            chapter_objectives_html: chapter_objectives_html
          )

        introduction_page.append(child:
          <<~HTML
            <div class="intro-body">
              #{chapter_outline}
              <div class="intro-text">
                #{title.paste}
                #{intro_content.paste}
              </div>
            </div>
          HTML
        )
      end

      Kitchen::Directions::BakeChapterIntroductions.v1_update_selectors(book)
    end
  end
end
