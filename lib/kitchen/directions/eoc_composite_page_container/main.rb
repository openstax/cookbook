# frozen_string_literal: true

module Kitchen
  module Directions
    module EocCompositePageContainer
      # Creates a wrapper for the given content & appends it to the given element
      #
      # @param container_key [String] Appended to 'eoc.' to form the I18n key for the container title; also used as part of a class on the container.
      # @param uuid_key [String] the uuid key for the wrapper class, e.g. `'.summary'`
      # @param metadata_source [MetadataElement] metadata for the book
      # @param content [String] the content to be contained by the wrapper
      # @param append_to [ElementBase] the element to be appended, usually either a `ChapterElement` or a `CompositeChapterElement`
      # @return [ElementBase] the append_to element with container appended
      #
      def self.v1(container_key:, uuid_key:, metadata_source:, content:,
                  append_to:)
        V1.new.bake(
          container_key: container_key,
          uuid_key: uuid_key,
          metadata_source: metadata_source,
          content: content,
          append_to: append_to
        )
      end
    end
  end
end
