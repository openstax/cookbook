# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeNonIntroductionPage
      def self.v1(page:, number:)
        page.search("div[data-type='description']").each(&:trash)
        page.add_class('chapter-content-module')

        title = page.title
        title.name = 'h2'
        title.replace_children(with:
          <<~HTML
            <span class="os-number">#{number}</span>
            <span class="os-divider"> </span>
            <span data-type="" itemprop="" class="os-text">#{title.text}</span>
          HTML
        )
      end
    end
  end
end
