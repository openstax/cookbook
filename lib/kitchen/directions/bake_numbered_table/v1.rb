# frozen_string_literal: true

module Kitchen::Directions::BakeNumberedTable
  class V1

    def bake(table:, number:, always_caption: false)
      table.remove_attribute('summary')
      table.wrap(%(<div class="os-table">))

      table_label = "#{I18n.t(:table_label)} #{number}"
      table.pantry(name: :link_text).store table_label, label: table.id

      if table.top_titled?
        table.parent.add_class('os-top-titled-container')
        table.prepend(sibling:
          <<~HTML
            <div class="os-table-title">#{table.title}</div>
          HTML
        )
        table.title_row.trash
      end

      table.parent.add_class('os-column-header-container') if table.column_header?

      # TODO: extra spaces added here to match legacy implementation, but probably not meaningful?
      new_caption = ''
      caption_title = ''

      if (title = table.first("span[data-type='title']")&.cut)
        caption_title = <<~HTML
          \n<span class="os-title" data-type="title">#{title.children}</span>
        HTML
      end

      if (caption = table.caption&.cut)
        new_caption = <<~HTML
          \n<span class="os-caption">#{caption.children}</span>
        HTML
      elsif always_caption
        new_caption = <<~HTML
          \n<span class="os-caption"></span>
        HTML
      end

      return if table.unnumbered?

      table.append(sibling:
        <<~HTML
          <div class="os-caption-container">
            <span class="os-title-label">#{I18n.t(:table_label)} </span>
            <span class="os-number">#{number}</span>
            <span class="os-divider"> </span>#{caption_title}
            <span class="os-divider"> </span>#{new_caption}
          </div>
        HTML
      )
    end

  end
end
