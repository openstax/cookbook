# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeHighlightedCode
      def self.v1(book:, languages:)
        # gives the code with the specified languages class a data-lang attribute for highlight.js
        languages.each do |language|
          book.search("code.#{language}, pre.#{language}").each do |code_block|
            code_block[:'data-lang'] = language
          end
        end
      end
    end
  end
end
