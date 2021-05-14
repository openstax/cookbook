# frozen_string_literal: true

module Kitchen
  module Directions
    # Bake directions for EOB references
    #
    module BakeReferences
      def self.v1(book:, metadata_source:)
        V1.new.bake(
          book: book,
          metadata_source: metadata_source
        )
      end
    end
  end
end
