# frozen_string_literal: true

module Kitchen::Directions::BakeChapterTitle
  class V1
    def bake(book:, cases: false)
      book.chapters.each do |chapter|
        fix_up_chapter_title(chapter: chapter, cases: cases)
      end
    end

    def fix_up_chapter_title(chapter:, cases:)
      heading = chapter.at('h1[2]')
      heading[:id] = "chapTitle#{chapter.count_in(:book)}"
      heading.replace_children(with:
        <<~HTML
          <span class="os-part-text">#{I18n.t("chapter#{'.nominative' if cases}")} </span>
          <span class="os-number">#{chapter.count_in(:book)}</span>
          <span class="os-divider"> </span>
          <span data-type="" itemprop="" class="os-text">#{heading.text}</span>
        HTML
      )
    end
  end
end
