module Kitchen
  module Directions
    module BakePreface
      def self.v1(book:)
        V1.new.bake(book: book)
      end
    end
  end
end
