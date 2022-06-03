# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeIndex
      def self.v1(book:, types: %w[main], uuid_prefix: nil, use_name_as_reference: false)
        V1.new.bake(book: book, types: types, uuid_prefix: uuid_prefix,
                    use_name_as_reference: use_name_as_reference)
      end
    end
  end
end
