# frozen_string_literal: true

module Kitchen::Directions::ChapterReviewContainer
  class V1
    renderable

    def bake(chapter:, metadata_source:)
      @metadata = metadata_source.children_to_keep.copy
      chapter.append(child: render(file: 'chapter_review.xhtml.erb'))
      chapter.first('div.os-eoc.os-chapter-review-container')
    end
  end
end
