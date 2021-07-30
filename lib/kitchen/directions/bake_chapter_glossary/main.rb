# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directons for eoc glossary
    #
    module BakeChapterGlossary
      def self.v1(chapter:, metadata_source:, append_to: nil, uuid_prefix: nil, has_para: false)
        V1.new.bake(
          chapter: chapter,
          metadata_source: metadata_source,
          append_to: append_to,
          uuid_prefix: uuid_prefix,
          has_para: has_para
        )
      end
    end
  end
end
