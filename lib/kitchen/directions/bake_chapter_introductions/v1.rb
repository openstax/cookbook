# frozen_string_literal: true

module Kitchen::Directions::BakeChapterIntroductions
  class V1
    def bake(book:)
      Kitchen::Directions::BakeChapterIntroductions.v2(
        book: book,
        strategy_options: {
          strategy: :add_objectives,
          bake_chapter_outline: true,
          introduction_order: :v1
        }
      )
    end
  end
end
