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
        caption&.name = 'span'
        caption&.add_class('os-caption')
        caption&.remove_attribute('id') # only needed for pl books, where captions have id
        caption_title_content =
          <<~HTML
            <span class="os-title-label">#{I18n.t("figure#{'.nominative' if cases}")} </span>
            <span class="os-number">#{number}</span>
            #{"<span class=\'os-divider\'> </span>" if title}
            #{"<span class=\'os-title\' data-type=\'title\' id=\"#{title.id}\">#{title.children}</span>" if title}
          HTML
        if figure.has_class?('mechanism-figure')
          figure.prepend(sibling:
            <<~HTML
              <div class="os-caption-title-container">
                #{caption_title_content}
              </div>
              <div class="os-caption-text-container">
                #{caption}
              </div>
            HTML
          )
        else
          figure.append(sibling:
            <<~HTML.chomp
              <div class="os-caption-container">
                #{caption_title_content}
                #{"<span class=\'os-divider\'> </span>" if caption}
                #{caption}
              </div>
            HTML
          )
        end
      end
    end
  end
end
