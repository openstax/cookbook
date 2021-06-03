# frozen_string_literal: true

module Kitchen::Directions::ChapterReviewContainer
  class V1
    renderable

    def bake(chapter:, metadata_source:, klass: 'chapter-review')
      @metadata = metadata_source.children_to_keep.copy
      @klass = klass
      @title = I18n.t(:"eoc.#{klass}")
      chapter.append(child: render(file: 'chapter_review.xhtml.erb'))
      chapter.element_children[-1]
    end
  end
end
