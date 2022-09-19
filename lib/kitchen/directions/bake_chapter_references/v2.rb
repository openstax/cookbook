# frozen_string_literal: true

module Kitchen::Directions::BakeChapterReferences
  class V2
    def bake(chapter:, metadata_source:, uuid_prefix: '.', klass: 'references')
      bake_cite(chapter: chapter)
      bake_references(chapter: chapter)

      return if chapter.references.none?

      content = chapter.references.cut.paste

      Kitchen::Directions::CompositePageContainer.v1(
        container_key: klass,
        uuid_key: "#{uuid_prefix}#{klass}",
        metadata_source: metadata_source,
        content: content,
        append_to: chapter
      )
    end

    def bake_cite(chapter:)
      chapter.search('[data-type="cite"]').each do |link|
        link.prepend(child:
          <<~HTML
            <sup class="os-end-note-number">#{link.count_in(:chapter)}</sup>
          HTML
        )

        link.search('.delete-me').trash
      end
    end

    def bake_references(chapter:)
      chapter.references.each do |reference|
        Kitchen::Directions::RemoveSectionTitle.v1(section: reference)

        reference.search('a').each do |ref_link|
          ref_link.replace_children(with:
            <<~HTML
              <span>#{ref_link.count_in(:chapter)}.</span>
            HTML
          )
        end
      end
    end
  end
end
