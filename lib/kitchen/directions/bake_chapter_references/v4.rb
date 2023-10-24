# frozen_string_literal: true

module Kitchen::Directions::BakeChapterReferences
  class V4
    def bake(chapter:, metadata_source:, klass: 'references')
      content = chapter.references.cut.paste

      Kitchen::Directions::CompositePageContainer.v1(
        container_key: klass,
        uuid_key: ".#{klass}",
        metadata_source: metadata_source,
        content: content,
        append_to: chapter
      )
    end
  end
end
