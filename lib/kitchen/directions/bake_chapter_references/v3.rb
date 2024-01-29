# frozen_string_literal: true

module Kitchen::Directions::BakeChapterReferences
  class V3

    def bake(chapter:, metadata_source:, append_to: nil, uuid_prefix: '.')
      Kitchen::Directions::BakeSortableSection.v1(
        chapter: chapter,
        metadata_source: metadata_source,
        klass: 'references',
        append_to: append_to || chapter,
        uuid_prefix: uuid_prefix
      )
    end
  end
end
