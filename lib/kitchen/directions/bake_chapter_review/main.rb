# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeChapterReview
      def self.v1(chapter:, metadata_source:)
        V1.new.bake(chapter: chapter, metadata_source: metadata_source)
      end
    end
  end
end
