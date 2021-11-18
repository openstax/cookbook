# frozen_string_literal: true

module Kitchen::Directions::BakeNumberedTable
  # Difference from v1: only in the caption
  # V2 caption titles are nested within an .os-caption span
  class V2

    def bake(table:, number:, cases: false)
      Kitchen::Directions::BakeTableBody::V1.new.bake(table: table, number: number, cases: cases)

      caption = ''
      if (table&.caption&.first("span[data-type='title']") || table&.caption) \
        && !table.top_captioned?
        caption_el = table.caption
        caption_el.add_class('os-caption')
        caption_el.name = 'span'
        caption = caption_el.cut
      end

      table.append(sibling:
        <<~HTML
          <div class="os-caption-container">
            <span class="os-title-label">#{I18n.t("table#{'.nominative' if cases}")} </span>
            <span class="os-number">#{number}</span>
            <span class="os-divider"> </span>
            #{caption}
          </div>
        HTML
      )

      table.parent.add_class('os-timeline-table-container') if table.has_class?('timeline-table')
    end
  end
end
