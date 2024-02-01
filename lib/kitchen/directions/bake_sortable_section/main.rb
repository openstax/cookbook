# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeSortableSection
      def self.v1(chapter:, metadata_source:, klass:, append_to: nil, uuid_prefix: '.')
        V1.new.bake(
          chapter: chapter,
          metadata_source: metadata_source,
          klass: klass,
          append_to: append_to,
          uuid_prefix: uuid_prefix
        )
      end
    end
  end
end
