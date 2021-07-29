# frozen_string_literal: true

# rubocop:disable Metrics/ParameterLists
# More parameters are ok here because these generic classes DRY up a lot of other code
module Kitchen::Directions::MoveCustomSectionToEocContainer
  class V1
    def bake(chapter:, metadata_source:, container_key:, uuid_key:,
             section_selector:, append_to:, include_intro_page:, wrap_section:, wrap_content:,
             &block)
      section_clipboard = Kitchen::Clipboard.new
      pages = include_intro_page ? chapter.pages : chapter.non_introduction_pages
      sections = pages.search(section_selector)
      sections.each(&block)
      if wrap_section
        sections.each { |section| section.wrap('<div class="os-section-area">') }
        sections = pages.search('div.os-section-area')
      end
      sections.cut(to: section_clipboard)

      return if section_clipboard.none?

      content = \
        if wrap_content
          <<~HTML
            <div class="os-#{container_key}">
              #{section_clipboard.paste}
            </div>
          HTML
        else
          section_clipboard.paste
        end

      Kitchen::Directions::EocCompositePageContainer.v1(
        container_key: container_key,
        uuid_key: uuid_key,
        metadata_source: metadata_source,
        content: content,
        append_to: append_to || chapter
      )
    end
  end
end
# rubocop:enable Metrics/ParameterLists
