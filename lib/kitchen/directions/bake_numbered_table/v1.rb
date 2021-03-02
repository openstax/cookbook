# frozen_string_literal: true

module Kitchen::Directions::BakeNumberedTable
  class V1

    def bake(table:, number:)
      table.wrap(%(<div class="os-table">))

      table_label = "#{I18n.t(:table_label)} #{number}"
      table.document.pantry(name: :link_text).store table_label, label: table.id

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
      new_summary = "#{table_label}  "
      new_caption = ''

      if (caption = table.caption&.cut)
        new_summary += caption.text
        new_caption = <<~HTML
          \n<span class="os-caption">#{caption.children}</span>
        HTML
      end

      table[:summary] = new_summary

      return if table.unnumbered?

      table.append(sibling:
        <<~HTML
          <div class="os-caption-container">
            <span class="os-title-label">#{I18n.t(:table_label)} </span>
            <span class="os-number">#{number}</span>
            <span class="os-divider"> </span>
            <span class="os-divider"> </span>#{new_caption}
          </div>
        HTML
      )
    end

  end
end
