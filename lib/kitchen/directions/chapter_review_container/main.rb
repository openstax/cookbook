# frozen_string_literal: true

module Kitchen
  module Directions
    module ChapterReviewContainer
      def self.v1(chapter:, metadata_source:, klass: 'chapter-review')
        V1.new.bake(chapter: chapter, metadata_source: metadata_source, klass: klass)
      end
    end
  end
end
