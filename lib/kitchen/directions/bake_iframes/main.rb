# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeIframes
      def self.v1(outer_element:)
        V1.new.bake(outer_element: outer_element)
      end
    end
  end
end
