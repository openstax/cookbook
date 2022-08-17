# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeFigure
      def self.v1(figure:, number:, cases: false)
        warn 'warning! exclude unnumbered figures from `BakeFigure` loop' if figure.unnumbered?
        figure.wrap(%(<div class="os-figure#{if figure.has_class?('splash')
                                               ' has-splash'
                                             elsif figure.has_class?('mechanism-figure')
                                               ' has-mechanism-figure'
                                             end}">))

        # Store label information
        figure.target_label(label_text: 'figure', custom_content: number, cases: cases)
        title = figure.title&.cut
        caption = figure.caption&.cut
        if figure.has_class?('mechanism-figure')
          figure.prepend(sibling:
            <<~HTML
              <div class="os-caption-title-container">
                <span class="os-title-label">#{I18n.t("figure#{'.nominative' if cases}")} </span>
                <span class="os-number">#{number}</span>
                #{"<span class=\'os-divider\'> </span>" if title}
                #{"<span class=\'os-title\' data-type=\'title\' id=\"#{title.id}\">#{title.children}</span>" if title}
              </div>
              <div class="os-caption-text-container">
                #{"<span class=\'os-caption\'>#{caption.children}</span>" if caption}
              </div>
            HTML
          )
        else
          figure.append(sibling:
            <<~HTML
              <div class="os-caption-container">
                <span class="os-title-label">#{I18n.t("figure#{'.nominative' if cases}")} </span>
                <span class="os-number">#{number}</span>
                #{"<span class=\'os-divider\'> </span>" if title}
                #{"<span class=\'os-title\' data-type=\'title\' id=\"#{title.id}\">#{title.children}</span>" if title}
                #{"<span class=\'os-divider\'> </span>" if caption}
                #{"<span class=\'os-caption\'>#{caption.children}</span>" if caption}
              </div>
            HTML
          )
        end
      end
    end
  end
end
