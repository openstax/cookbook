# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeUnnumberedTables
      def self.v1(book:)
        book.tables('$:not(.hljs-ln), .unnumbered').each do |table|
          table.wrap(%(<div class="os-table">))
          table.remove_attribute('summary')
          table.parent.add_class('os-unstyled-container') if table.unstyled?
          table.parent.add_class('os-no-cellborder-container') if table.no_cellborder_table?
          table.parent.add_class('os-column-header-container') if table.column_header?
          if table.top_titled?
            table.parent.add_class('os-top-titled-container')

            if table.first('thead') && table.title
              table.prepend(sibling:
                <<~HTML
                  <div class="os-table-title">#{table.title}</div>
                HTML
              )
              table.title_row.trash
            end
          end

          table.search('th').each do |header|
            header[:scope] = if header[:colspan].nil? || header[:colspan] == '1'
                               'col'
                             else
                               'colgroup'
                             end
          end

          if (title = table.first("span[data-type='title']")&.cut)
            caption_title = <<~HTML
              \n<span class="os-title" data-type="title">#{title.children}</span>
            HTML
          end

          if (caption = table.caption&.cut) && !caption&.children&.to_s&.blank?
            caption_text = <<~HTML
              \n<span class="os-caption">#{caption.children}</span>
            HTML
          end

          next unless caption_text || caption_title

          sibling = <<~HTML
            <div class="os-caption-container">
              #{caption_title}
              <span class="os-divider"> </span>#{caption_text}
            </div>
          HTML

          table.append(sibling: sibling)
        end
      end
    end
  end
end
