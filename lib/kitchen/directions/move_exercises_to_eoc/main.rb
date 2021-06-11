# frozen_string_literal: true

module Kitchen
  module Directions
    module MoveExercisesToEOC
      def self.v1(chapter:, metadata_source:, klass:, append_to: nil, uuid_prefix: '.')
        V1.new.bake(
          chapter: chapter,
          metadata_source: metadata_source,
          append_to: append_to,
          klass: klass,
          uuid_prefix: uuid_prefix
        )
      end

      def self.v2(chapter:, metadata_source:, klass:, append_to: nil, uuid_prefix: '.')
        V2.new.bake(
          chapter: chapter,
          metadata_source: metadata_source,
          append_to: append_to,
          klass: klass,
          uuid_prefix: uuid_prefix
        )
      end

      def self.v3(chapter:, metadata_source:, klass:, append_to: nil, uuid_prefix: '.')
        V3.new.bake(
          chapter: chapter,
          metadata_source: metadata_source,
          append_to: append_to,
          klass: klass,
          uuid_prefix: uuid_prefix
        )
      end
    end
  end
end
