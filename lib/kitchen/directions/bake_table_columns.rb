# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeTableColumns
      def self.v1(book:)
        book.tables.each do |table|
          columns = table.search('col').count
          next if columns <= 1

          table['data-columns'] = columns.to_s

          ratio_list = []

          table.search('col').each do |column|
            next if column['data-width'].nil?
            ratio = column['data-width'].gsub('*', '')
            ratio_list.push(ratio)
          end

          table['data-ratio'] = ratio_list.join(',')
        end
      end
    end
  end
end
