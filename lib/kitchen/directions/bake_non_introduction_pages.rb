# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeNonIntroductionPages
      def self.v1(chapter:, add_target_label: false)
        chapter.non_introduction_pages.each do |page|
          number = "#{chapter.count_in(:book)}.#{page.count_in(:chapter)}"

          page.search("div[data-type='description']").each(&:trash)
          page.add_class('chapter-content-module')

          page.target_label(custom_content: number) if add_target_label

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
end
