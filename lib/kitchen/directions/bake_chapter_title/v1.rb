# frozen_string_literal: true

module Kitchen::Directions::BakeChapterTitle
  class V1
    def bake(book:, cases: false)
      book.chapters.each do |chapter|
        fix_up_chapter_title(
          chapter: chapter,
          cases: cases,
          numbering_options: { mode: :chapter_page, separator: '.' })
      end
    end

    protected

    def fix_up_chapter_title(chapter:, cases:, numbering_options:)
      heading = chapter.at('h1[2]')
      heading[:id] = "chapTitle#{chapter.count_in(:book)}"
      number = chapter.os_number(numbering_options)
      heading.replace_children(with:
        <<~HTML
          <span class="os-part-text">#{I18n.t("chapter#{'.nominative' if cases}")} </span>
          <span class="os-number">#{number}</span>
          <span class="os-divider"> </span>
          <span data-type="" itemprop="" class="os-text">#{heading.text}</span>
        HTML
      )
    end
  end
end
