# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeFigure
      def self.v1(figure:, number:, cases: false)
        warn 'warning! exclude unnumbered figures from `BakeFigure` loop' if figure.unnumbered?
        figure.wrap(%(<div class="os-figure#{' has-splash' if figure.has_class?('splash')}">))

        # Store label information
        figure.target_label(label_text: 'figure', custom_content: number, cases: cases)

        title = figure.title&.cut
        caption = figure.caption&.cut
        figure.append(sibling:
          <<~HTML
            <div class="os-caption-container">
              <span class="os-title-label">#{I18n.t("figure#{'.nominative' if cases}")} </span>
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
