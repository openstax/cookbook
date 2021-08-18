# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeIndex
      def self.v1(book:, types: %w[main], uuid_prefix: nil)
        V1.new.bake(book: book, types: types, uuid_prefix: uuid_prefix)
      end
    end
  end
end
