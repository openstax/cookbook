# frozen_string_literal: true

module Kitchen
  module Directions
    module MoveTitleTextIntoSpan
      def self.v1(title:)
        title.replace_children(with:
          <<~HTML
            <span data-type="" itemprop="" class="os-text">#{title.text}</span>
          HTML
        )
      end
    end
  end
end
