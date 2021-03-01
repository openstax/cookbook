# frozen_string_literal: true
module Kitchen
  module Directions
    module BakeFigure
      def self.v1(figure:, number:)
        figure.wrap(%(<div class="os-figure#{' has-splash' if figure.has_class?('splash')}">))

        figure.document.pantry(name: :link_text).store "Figure #{number}", label: figure.id

        caption = figure.caption&.cut
        figure.append(sibling:
          <<~HTML
            <div class="os-caption-container">
              <span class="os-title-label">Figure </span>
              <span class="os-number">#{number}</span>
              <span class="os-divider"> </span>
              <span class="os-divider"> </span>
              #{'<span class="os-caption">' + caption.children.to_s + '</span>' if caption}
            </div>
          HTML
        )
      end
    end
  end
end
