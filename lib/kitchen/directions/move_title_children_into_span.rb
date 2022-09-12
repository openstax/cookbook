# frozen_string_literal: true

module Kitchen
  module Directions
    module MoveTitleChildrenIntoSpan
      def self.v1(title:)
        title.replace_children(with:
          <<~HTML
            <span data-type="" itemprop="" class="os-text">#{title.children}</span>
          HTML
        )
      end
    end
  end
end
