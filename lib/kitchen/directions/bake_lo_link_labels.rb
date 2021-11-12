# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for LO link labels
    module BakeLOLinkLabels
      def self.v1(book:)
        book.search('a.lo-reference').each do |anchor|
          anchor.wrap_children('span', class: 'label-counter')
          anchor.prepend(child:
            <<~HTML
              <span class="label-text">#{I18n.t(:lo_label_text)}</span>
            HTML
          )
        end
      end
    end
  end
end
