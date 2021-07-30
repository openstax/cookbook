# frozen_string_literal: true

module Kitchen
  module Directions
    # Bakes lists with paragraphs
    # Should be used for books created by Adaptarr to put list text directly to <li>
    #
    module BakeListsWithPara
      def self.v1(book:)
        book.search('li').each do |item|
          item_content = item.first('p')&.text
          item.replace_children with: item_content unless item_content.nil?
        end
      end
    end
  end
end
