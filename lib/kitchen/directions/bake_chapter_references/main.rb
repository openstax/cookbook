# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeChapterReferences
      def self.v1(chapter:, metadata_source:, uuid_prefix: '.', klass: 'references')
        V1.new.bake(
          chapter: chapter,
          metadata_source: metadata_source,
          uuid_prefix: uuid_prefix,
          klass: klass)
      end

      def self.v2(chapter:, metadata_source:, uuid_prefix: '.', klass: 'references')
        V2.new.bake(
          chapter: chapter,
          metadata_source: metadata_source,
          uuid_prefix: uuid_prefix,
          klass: klass)
      end
    end
  end
end
