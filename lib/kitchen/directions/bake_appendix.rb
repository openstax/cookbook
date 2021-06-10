# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeAppendix
      def self.v1(page:, number:)
        title = page.title
        title.name = 'h1'
        title.replace_children(with:
          <<~HTML
            <span class="os-part-text">#{I18n.t(:appendix)} </span>
            <span class="os-number">#{number}</span>
            <span class="os-divider"> </span>
            <span data-type="" itemprop="" class="os-text">#{title.children}</span>
          HTML
        )

        # Make a section with data-depth of X have a header level of X+1
        page.search('section').each do |section|
          title = section.titles.first
          next unless title.present?

          title.name = "h#{section['data-depth'].to_i + 1}"
        end
      end
    end
  end
end
