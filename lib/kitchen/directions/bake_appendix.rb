# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeAppendix
      def self.v1(page:, number:, options: {
        block_target_label: false,
        cases: false,
        add_title_label: true
      })

        options.reverse_merge!(
          block_target_label: false,
          cases: false,
          add_title_label: true
        )

        title = page.title
        title.name = 'h1'

        # Store label information
        title_label = title.children
        custom_content = options[:add_title_label] ? "#{number} #{title_label}" : number.to_s

        unless options[:block_target_label]
          page.target_label(
            label_text: 'appendix',
            custom_content: custom_content,
            cases: options[:cases]
          )
        end

        title.replace_children(with:
          <<~HTML
            <span class="os-part-text">#{I18n.t("appendix#{'.nominative' \
            if options[:cases]}")} </span>
            <span class="os-number">#{number}</span>
            <span class="os-divider"> </span>
            <span data-type="" itemprop="" class="os-text">#{title.children}</span>
          HTML
        )

        # Make a section with data-depth of X have a header level of X+1
        page.search('section:not(.learning-objectives)').each do |section|
          title = section.titles.first
          next unless title.present?

          title.name = "h#{section['data-depth'].to_i + 1}"
          section.name = 'div' if section.has_class?('column-container')
        end
      end
    end
  end
end
