# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeTheorem
      def self.v1(theorem:, number:)
        V1.new.bake(theorem: theorem, number: number)
      end
    end
  end
end
