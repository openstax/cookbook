# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeNonIntroductionPages
      def self.v1(chapter:, options: {
        custom_target_label: false,
        block_target_label: false,
        cases: false
      })
        options.reverse_merge!(
          custom_target_label: false,
          block_target_label: false,
          cases: false
        )
        chapter.non_introduction_pages.each do |page|
          number = "#{chapter.count_in(:book)}.#{page.count_in(:chapter)}"

          page.search("div[data-type='description']").each(&:trash)
          page.add_class('chapter-content-module')

          title = page.title
          title_label = title.children

          if options[:custom_target_label]
            page.custom_target_label_for_modules(custom_title_content: " #{title_label}",
                                                 custom_number_content: number)
          elsif !options[:block_target_label]
            if options[:cases]
              page.target_label(label_text: 'module', custom_content: "#{number} #{title_label}", cases: options[:cases])
            else
              page.target_label(custom_content: "#{number} #{title_label}")
            end
          end

          title.name = 'h2'
          title.id = "#{page.id}_titlecreatedbycookbook"
          title.replace_children(with:
            <<~HTML
              <span class="os-number">#{number}</span>
              <span class="os-divider"> </span>
              <span data-type="" itemprop="" class="os-text">#{page.title.children}</span>
            HTML
          )
        end
      end
    end
  end
end
