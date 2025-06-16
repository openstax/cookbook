# frozen_string_literal: true

module Kitchen::Directions::BakeChapterTitle
  class V2 < V1
    def bake(chapters:, cases: false, numbering_options: {})
      chapters.each do |chapter|
        fix_up_chapter_title(
          chapter: chapter,
          cases: cases,
          numbering_options: numbering_options)
      end
    end
  end
end
