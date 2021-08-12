# frozen_string_literal: true

module Kitchen::Directions::BakeNumberedTable
  # Difference from v1: only in the caption
  # V2 caption titles are nested within an .os-caption span
  class V2

    def bake(table:, number:)
      Kitchen::Directions::BakeTableBody::V1.new.bake(table: table, number: number)

      caption = ''
      if table&.caption&.first("span[data-type='title']") && !table.top_captioned?
        caption_el = table.caption
        caption_el.add_class('os-caption')
        caption_el.name = 'span'
        caption = caption_el.cut
      end

      table.append(sibling:
        <<~HTML
          <div class="os-caption-container">
            <span class="os-title-label">#{I18n.t(:table_label)} </span>
            <span class="os-number">#{number}</span>
            <span class="os-divider"> </span>
            #{caption}
          </div>
        HTML
      )
    end
  end
end
