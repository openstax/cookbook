# frozen_string_literal: true

module Kitchen
  module Directions
    # Bakes lists with paragraphs
    # Should be used for books created by Adaptarr to put list content directly to <li>
    #
    module BakeListsWithPara
      def self.v1(book:)
        book.search('li').each do |item|
          item_para = item.first('p')&.cut
          item.replace_children with: item_para.children unless item_para.nil?
        end
      end
    end
  end
end
