# frozen_string_literal: true

module Kitchen
  module Directions
    # Add attributes to links
    #
    module BakeLinks
      def self.v1(book:)
        book.search('a').each do |anchor|
          # Add attributes to links that start with https://, http://, or //
          # For Rex
          if anchor&.[](:href)&.match(/^https:\/\/|^http:\/\/|^\/\//)
            anchor[:target] = '_blank'
            anchor[:rel] = 'noopener nofollow'
          elsif anchor&.[](:href)&.match(/^\.\.\//)
            anchor[:target] = '_blank'
            anchor.remove_attribute('rel')
          end
        end
      end
    end
  end
end
