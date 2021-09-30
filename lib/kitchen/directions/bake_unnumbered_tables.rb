# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeUnnumberedTables
      def self.v1(book:)
        book.tables('$.unnumbered').each do |table|
          table.wrap(%(<div class="os-table">))
          table.remove_attribute('summary')
          table.parent.add_class('os-unstyled-container') if table.unstyled?
          table.parent.add_class('os-column-header-container') if table.column_header?
          table.parent.add_class('os-top-titled-container') if table.top_titled?
        end
      end
    end
  end
end
