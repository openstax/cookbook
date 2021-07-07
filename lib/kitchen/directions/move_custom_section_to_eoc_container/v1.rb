# frozen_string_literal: true

# rubocop:disable Metrics/ParameterLists
# More parameters are ok here because these generic classes DRY up a lot of other code
module Kitchen::Directions::MoveCustomSectionToEocContainer
  class V1
    renderable

    def bake(chapter:, metadata_source:, container_key:, uuid_key:,
             section_selector:, append_to:, include_intro_page:, &block)
      section_clipboard = Kitchen::Clipboard.new
      pages = include_intro_page ? chapter.pages : chapter.non_introduction_pages
      sections = pages.search(section_selector)
      sections.each(&block)
      sections.cut(to: section_clipboard)

      return if section_clipboard.none?

      Kitchen::Directions::EocCompositePageContainer.v1(
        container_key: container_key,
        uuid_key: uuid_key,
        metadata_source: metadata_source,
        content: section_clipboard.paste,
        append_to: append_to || chapter
      )
    end
  end
end
# rubocop:enable Metrics/ParameterLists
