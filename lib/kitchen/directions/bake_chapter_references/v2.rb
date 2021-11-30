# frozen_string_literal: true

module Kitchen::Directions::BakeChapterReferences
  class V2
    def bake(chapter:, metadata_source:, uuid_prefix: '.', klass: 'references')
      chapter.pages.each do |page|
        bake_page_cite(page: page)
        bake_page_references(page: page)
      end

      return if chapter.pages.references.none?

      content = chapter.pages.references.cut.paste

      Kitchen::Directions::CompositePageContainer.v1(
        container_key: klass,
        uuid_key: "#{uuid_prefix}#{klass}",
        metadata_source: metadata_source,
        content: content,
        append_to: chapter
      )
    end

    def bake_page_cite(page:)
      page.search('[data-type="cite"]').each do |link|
        link.id = "#{page.id}-endNote#{link.count_in(:chapter)}"

        link.prepend(child:
          <<~HTML
            <sup class="os-end-note-number">#{link.count_in(:chapter)}</sup>
          HTML
        )

        link.search('.delete-me').trash
      end
    end

    def bake_page_references(page:)
      page.references.each do |reference|
        Kitchen::Directions::RemoveSectionTitle.v1(section: reference)

        reference.search('a').each do |ref_link|
          ref_link.replace_children(with:
            <<~HTML
              <span>#{ref_link.count_in(:chapter)}.</span>
            HTML
          )
          ref_link.href = "##{page.id}-endNote#{ref_link.count_in(:chapter)}"
        end
      end
    end
  end
end
