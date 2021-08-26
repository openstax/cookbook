# frozen_string_literal: true

module Kitchen::Directions::BakeChapterIntroductions
  class BakeChapterOutline
    def bake(chapter_objectives_html:)
      <<~HTML
        <div class="os-chapter-outline">
          <h3 class="os-title">#{I18n.t(:chapter_outline)}</h3>
          #{chapter_objectives_html}
        </div>
      HTML
    end
  end
end
