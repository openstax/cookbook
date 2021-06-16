# frozen_string_literal: true

module Kitchen
  module Directions
    # Bakes inline lists with the desired list separator
    # Does not separate the last list item
    #
    module BakeInlineLists
      LIST_SEPARATOR = '; '
      SEPARATOR_CLASS = '-os-inline-list-separator'

      def self.v1(book:)
        inline_lists = book.search('span[data-display="inline"][data-type="list"]')
        inline_lists.each do |list|
          list.search('span[data-type="item"]')[0..-2].each do |item|
            item.append(child: "<span class=\"#{SEPARATOR_CLASS}\">#{LIST_SEPARATOR}</span>")
          end
        end
      end
    end
  end
end
