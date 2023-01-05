# frozen_string_literal: true

module Kitchen::Directions::BakeNumberedTable
  class V1

    def bake(table:, number:, cases: false, label_class: nil)
      Kitchen::Directions::BakeTableBody::V1.new.bake(table: table,
                                                      number: number,
                                                      cases: cases,
                                                      label_class: label_class)

      # TODO: extra spaces added here to match legacy implementation, but probably not meaningful?
      new_caption = ''
      caption_title = ''

      if (title = table.first("span[data-type='title']")&.cut)
        caption_title = <<~HTML
          \n<span class="os-title" data-type="title">#{title.children}</span>
        HTML
      end

      if (caption = table.caption&.cut) && !caption&.children&.to_s&.blank?
        new_caption = <<~HTML
          \n<span class="os-caption">#{caption.children}</span>
        HTML
      end

      return if table.unnumbered?

      table.append(sibling:
        <<~HTML
          <div class="os-caption-container">
            <span class="os-title-label">#{I18n.t("table#{'.nominative' if cases}")} </span>
            <span class="os-number">#{number}</span>
            <span class="os-divider"> </span>#{caption_title}
            <span class="os-divider"> </span>#{new_caption}
          </div>
        HTML
      )

      return unless table.baked_caption

      Kitchen::Directions::BakeAsideInCaption.v1(
        caption_container: table.baked_caption
      )
    end
  end
end
