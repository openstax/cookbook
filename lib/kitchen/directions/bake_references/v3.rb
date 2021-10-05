# frozen_string_literal: true

module Kitchen::Directions::BakeReferences
  class V3
    def bake(book:, metadata_source:)
      return unless book.references.any?

      book.chapters.pages.each do |page|
        page.references.each do |reference|
          reference.titles.trash
          reference.prepend(child:
            Kitchen::Directions::EocSectionTitleLinkSnippet.v1(
              page: page,
              title_tag: 'h2',
              wrapper: nil
            )
          )
        end
      end

      chapter_area_references = book.chapters.references.cut

      Kitchen::Directions::CompositePageContainer.v1(
        container_key: 'references',
        uuid_key: '.references',
        metadata_source: metadata_source,
        content: chapter_area_references.paste,
        append_to: book.body
      )
    end
  end
end
