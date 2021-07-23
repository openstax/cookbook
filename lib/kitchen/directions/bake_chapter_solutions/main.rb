# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeChapterSolutions
      def self.v1(chapter:, metadata_source:, uuid_prefix: '', classes: %w[free-response])
        V1.new.bake(
          chapter: chapter,
          metadata_source: metadata_source,
          uuid_prefix: uuid_prefix,
          classes: classes
        )
      end
    end
  end
end
