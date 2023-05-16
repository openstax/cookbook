# frozen_string_literal: true

module Kitchen
  module Directions
    module UseSectionTitle
      def self.v1(chapter:, eoc_selector: '', section_selector: '')
        composite_page = chapter.search(eoc_selector).first
        return if composite_page.nil?

        section = composite_page.search(section_selector).first

        section_title = section.first('[data-type="title"]')

        composite_page_title = composite_page.first('[data-type="document-title"]')

        composite_page_title.append(child:
          <<~HTML
            <span class="os-divider">&mdash;</span>
            <span class="os-subtitle">#{section_title.text}</span>
          HTML
        )

        section_title.trash
      end
    end
  end
end
