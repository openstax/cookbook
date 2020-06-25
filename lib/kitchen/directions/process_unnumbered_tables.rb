module Kitchen
  module Directions
    module ProcessUnnumberedTables

      # TODO "Bake" may be better than "Process" in all of these directions

      def self.v1(book:)
        book.tables("$.unnumbered").each do |table|
          table.wrap(%Q(<div class="os-table">))
          table.remove_attribute("summary")
        end
      end

    end
  end
end
