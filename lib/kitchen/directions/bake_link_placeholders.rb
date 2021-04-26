# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for link placeholders
    #
    module BakeLinkPlaceholders
      def self.v1(book:)
        book.search('a').each do |anchor|
          next unless anchor.text == '[link]'

          id = anchor[:href][1..-1]
          replacement = book.pantry(name: :link_text).get(id)
          if replacement.present?
            anchor.replace_children(with: replacement)
          else
            # TODO: log a warning!
            puts "warning! could not find a replacement for '[link]' on an element with ID '#{id}'"
          end
        end
      end
    end
  end
end
