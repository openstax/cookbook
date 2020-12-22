module Kitchen
  module Directions
    module BakeUnnumberedTables
      def self.v1(book:)
        book.tables('$.unnumbered').each do |table|
          table.wrap(%(<div class="os-table">))
          table.remove_attribute('summary')
        end
      end
    end
  end
end
