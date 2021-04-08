# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeChapterReviewExercises
      def self.v1(chapter:, metadata_source:, append_to:, klass:)
        V1.new.bake(chapter: chapter, metadata_source: metadata_source, append_to: append_to, klass: klass)
      end

      def self.v2(chapter:, metadata_source:, append_to:, klass:)
        V2.new.bake(chapter: chapter, metadata_source: metadata_source, append_to: append_to, klass: klass)
      end
    end
  end
end
