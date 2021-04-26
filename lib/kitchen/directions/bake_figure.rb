# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeFigure
      def self.v1(figure:, number:)
        figure.wrap(%(<div class="os-figure#{' has-splash' if figure.has_class?('splash')}">))

        figure.pantry(name: :link_text).store "#{I18n.t(:figure)} #{number}", label: figure.id
        title = figure.title&.cut

        caption = figure.caption&.cut
        figure.append(sibling:
          <<~HTML
            <div class="os-caption-container">
              <span class="os-title-label">#{I18n.t(:figure)} </span>
              <span class="os-number">#{number}</span>
              <span class="os-divider"> </span>
              #{"<span class=\"os-title\" data-type=\"title\" id=\"#{title.id}\">#{title.children}</span>" if title}
              <span class="os-divider"> </span>
              #{"<span class=\"os-caption\">#{caption.children}</span>" if caption}
            </div>
          HTML
        )
      end
    end
  end
end
