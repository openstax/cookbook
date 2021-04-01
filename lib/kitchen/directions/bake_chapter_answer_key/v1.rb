# frozen_string_literal: true

module Kitchen::Directions::BakeChapterAnswerKey
  class V1
    def bake(chapter:, metadata_source:, strategy:, append_to:)
      strategy =
        case strategy
        when :calculus
          Strategies::Calculus
        else
          raise 'No such strategy'
        end

      append_to.append(child:
        <<~HTML
          <div class="os-eob os-solutions-container" data-type="composite-page" data-uuid-key=".solutions#{chapter.count_in(:book)}">
            <h2 data-type="document-title">
              <span class="os-text">#{I18n.t(:chapter)} #{chapter.count_in(:book)}</span>
            </h2>
            #{metadata_source.copy}
          </div>
        HTML
      )
      strategy.new.bake(chapter: chapter, append_to: append_to.last_element)
    end
  end
end
