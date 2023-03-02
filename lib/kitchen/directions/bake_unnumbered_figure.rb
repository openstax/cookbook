# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeUnnumberedFigure
      def self.v1(book:)
        book.figures(only: :unnumbered?).each do |figure|

          figure.wrap(%(<div class="os-figure#{' has-splash' if figure.has_class?('splash')}">))
          next unless figure.caption || figure.title

          title = figure.title&.cut
          caption = figure.caption&.cut
          figure.append(sibling:
            <<~HTML
              <div class="os-caption-container">
                #{"<span class=\"os-title\" data-type=\"title\">#{title.children}</span>" if title}
                #{'<span class="os-divider"> </span>' if title && caption}
                #{"<span class=\"os-caption\">#{caption.children}</span>" if caption}
              </div>
            HTML
          )
        end
      end
    end
  end
end
