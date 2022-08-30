# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeFigure
      def self.v1(figure:, number:, cases: false, label_class: nil)
        warn 'warning! exclude unnumbered figures from `BakeFigure` loop' if figure.unnumbered?
        figure.wrap(%(<div class="os-figure#{' has-splash' if figure.has_class?('splash')}">))

        # Store label information
        figure.target_label(
          label_text: 'figure',
          custom_content: number,
          cases: cases,
          label_class: label_class
        )

        title = figure.title&.cut
        caption = figure.caption&.cut
        caption&.name = 'span'
        caption&.add_class('os-caption')
        caption&.remove_attribute('id') # only needed for pl books, where captions have id

        figure.append(sibling:
          <<~HTML.chomp
            <div class="os-caption-container">
              <span class="os-title-label">#{I18n.t("figure#{'.nominative' if cases}")} </span>
              <span class="os-number">#{number}</span>
              #{"<span class=\'os-divider\'> </span>" if title}
              #{"<span class=\'os-title\' data-type=\'title\' id=\"#{title.id}\">#{title.children}</span>" if title}
              #{"<span class=\'os-divider\'> </span>" if caption}
              #{caption}
            </div>
          HTML
        )
      end
    end
  end
end
