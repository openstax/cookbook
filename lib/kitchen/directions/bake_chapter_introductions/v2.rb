# frozen_string_literal: true

module Kitchen::Directions::BakeChapterIntroductions
  class V2
    def bake(book:, strategy_options:)
      book.chapters.each do |chapter|
        introduction_page = chapter.introduction_page
        title = bake_title(introduction_page: introduction_page)

        chapter_intro_html =
          Kitchen::Directions::BakeChapterIntroductions.bake_chapter_objectives(
            chapter: chapter,
            strategy: strategy_options[:strategy]
          )

        if strategy_options[:bake_chapter_outline]
          chapter_intro_html =
            Kitchen::Directions::BakeChapterIntroductions.bake_chapter_outline(
              chapter_objectives_html: chapter_intro_html
            )
        end

        case strategy_options[:introduction_order]
        when :v1
          v1_introduction_order(
            introduction_page: introduction_page,
            chapter_intro_html: chapter_intro_html,
            title: title
          )
        when :v2
          v2_introduction_order(
            introduction_page: introduction_page,
            chapter_intro_html: chapter_intro_html,
            title: title
          )
        end
      end

      Kitchen::Directions::BakeChapterIntroductions.v1_update_selectors(book)
    end

    def v1_introduction_order(introduction_page:, chapter_intro_html:, title:)
      intro_content = introduction_page.search(
        "> :not([data-type='metadata']):not(.splash):not(.has-splash)"
      ).cut

      introduction_page.append(child:
        <<~HTML
          <div class="intro-body">
            #{chapter_intro_html}
            <div class="intro-text">
              #{title.paste}
              #{intro_content.paste}
            </div>
          </div>
        HTML
      )
    end

    def v2_introduction_order(introduction_page:, chapter_intro_html:, title:)
      if chapter_intro_html.empty?
        chapter_intro_html = introduction_page.notes('$.chapter-objectives').first&.cut&.paste
      end
      extra_content = introduction_page.search(
        '> :not([data-type="metadata"]):not(.splash):not(.has-splash)'
      ).cut

      introduction_page.append(child:
        <<~HTML
          <div class="intro-body">
            #{chapter_intro_html}
            <div class="intro-text">
              #{title.paste}
              #{extra_content.paste}
            </div>
          </div>
        HTML
      )
    end

    def bake_title(introduction_page:)
      introduction_page.search(
        'div[data-type="description"], div[data-type="abstract"]'
      ).each(&:trash)

      title = introduction_page.title.cut
      title.name = 'h2'
      Kitchen::Directions::MoveTitleTextIntoSpan.v1(title: title)
    end
  end
end
