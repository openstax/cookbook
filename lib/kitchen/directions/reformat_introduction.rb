module Directions

  # TODO? module ReformatIntroduction; def v1(chapter)

  def self.reformat_introduction(chapter)
    outline_items_html = chapter.pages.map do |page|
      next if page.is_introduction?

      <<~HTML
        <div class="os-chapter-objective">
          <a class="os-chapter-objective" href="##{page.title[:id]}">
            <span class="os-number">#{chapter.number}.#{page.number}</span>
            <span class="os-divider"> </span>
            <span data-type="" itemprop="" class="os-text">#{page.title.children[0].text}</span>
          </a>
        </div>
      HTML
    end.join("")

    introduction_page = chapter.introduction_page

    introduction_page.each("div[data-type='description']", &:trash)

    title = introduction_page.title.cut  # TODO add a paste method to element that dumps to_s
    title.name = "h2"

    intro_content = introduction_page.elements("> :not([data-type='metadata']):not(.has-splash)").cut

    introduction_page.append(child:
      <<~HTML
        <div class="intro-body">
          <div class="os-chapter-outline">
            <h3 class="os-title">Chapter Outline</h3>
            #{outline_items_html}
          </div>
          <div class="intro-text">
            #{title.to_html}
            #{intro_content.paste}
          </div>
        </div>
      HTML
    )
  end

end
