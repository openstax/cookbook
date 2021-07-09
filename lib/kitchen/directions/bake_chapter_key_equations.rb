# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directons for eoc key equations
    #
    module BakeChapterKeyEquations
      def self.v1(chapter:, metadata_source:, append_to: nil, uuid_prefix: '.')
        V1.new.bake(
          chapter: chapter,
          metadata_source: metadata_source,
          append_to: append_to,
          uuid_prefix: uuid_prefix
        )
      end

      class V1
        def bake(chapter:, metadata_source:, append_to:, uuid_prefix:)
          MoveCustomSectionToEocContainer.v1(
            chapter: chapter,
            metadata_source: metadata_source,
            container_key: 'key-equations',
            uuid_key: "#{uuid_prefix}key-equations",
            section_selector: 'section.key-equations',
            append_to: append_to
          ) do |section|
            RemoveSectionTitle.v1(section: section)
          end
        end
      end
    end
  end
end
