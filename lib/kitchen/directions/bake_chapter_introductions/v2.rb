# frozen_string_literal: true

module Kitchen::Directions::BakeChapterIntroductions
  class V2
    def bake(book:, chapters:, options:)
      chapters.each do |chapter|
        introduction_page = chapter.introduction_page
        number = chapter.os_number(options[:numbering_options])
        title_label = chapter.title.search('.os-text').first&.text
        title_label = chapter.title.text if title_label.nil?

        introduction_page.target_label(label_text: 'chapter', custom_content: "#{number} #{title_label}", cases: options[:cases]) unless options[:block_target_label]

        title = bake_title(introduction_page: introduction_page)

        chapter_intro_html =
          Kitchen::Directions::BakeChapterIntroductions.bake_chapter_objectives(
            chapter: chapter,
            strategy: options[:strategy],
            options: options
          )

        if options[:bake_chapter_outline]
          chapter_intro_html =
            Kitchen::Directions::BakeChapterIntroductions.bake_chapter_outline(
              chapter_objectives_html: chapter_intro_html
            )
        end

        order(
          options: options,
          introduction_page: introduction_page,
          chapter_intro_html: chapter_intro_html,
          title: title
        )
      end

      Kitchen::Directions::BakeChapterIntroductions.v1_update_selectors(book)
    end

    def order(options:, introduction_page:, chapter_intro_html:, title:)
      case options[:introduction_order]
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
      when :v3
        v3_introduction_order(
          introduction_page: introduction_page,
          chapter_intro_html: chapter_intro_html,
          title: title
        )
      when :v4
        v4_introduction_order(
          introduction_page: introduction_page,
          chapter_intro_html: chapter_intro_html,
          title: title
        )
      end
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

    def v3_introduction_order(introduction_page:, chapter_intro_html:, title:)
      intro_content = introduction_page.search(
        "> :not([data-type='metadata']):not(.splash):not(.has-splash):not(.unit-opener)"
      ).cut

      unit_opener_note = introduction_page.search('[data-type="note"].unit-opener').cut

      introduction_page.append(child:
        <<~HTML
          <div class="intro-body">
            #{unit_opener_note.paste}
            #{chapter_intro_html}
            <div class="intro-text">
              #{title.paste}
              #{intro_content.paste}
            </div>
          </div>
        HTML
      )
    end

    def v4_introduction_order(introduction_page:, chapter_intro_html:, title:)
      intro_content = introduction_page.search(
        "> :not([data-type='metadata']):not(.splash):not(.has-splash):not(.meet-author)"
      ).cut

      meet_author_note = introduction_page.search('[data-type="note"].meet-author').cut

      introduction_page.append(child:
        <<~HTML
          <div class="intro-body">
            #{chapter_intro_html}
            #{meet_author_note.paste}
            <div class="intro-text">
              #{title.paste}
              #{intro_content.paste}
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
      title.id = "#{introduction_page.id}_titlecreatedbycookbook"
      Kitchen::Directions::MoveTitleChildrenIntoSpan.v1(title: title)
    end
  end
end
