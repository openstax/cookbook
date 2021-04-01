# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeChapterKeyConcepts
      def self.v1(chapter:, metadata_source:, append_to: nil)
        V1.new.bake(chapter: chapter, metadata_source: metadata_source, append_to: append_to)
      end
    end
  end
end
