# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for table body
    #
    module BakeTableBody
      def self.v1(table:, number:)
        table.remove_attribute('summary')
        table.wrap(%(<div class="os-table">))

        table_label = "#{I18n.t(:table_label)} #{number}"
        table.pantry(name: :link_text).store table_label, label: table.id if table.id

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
      end
    end
  end
end
