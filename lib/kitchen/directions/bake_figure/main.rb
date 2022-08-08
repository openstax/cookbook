# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeFigure
      def self.v1(figure:, number:, cases: false)
        V1.new.bake(figure: figure, number: number, cases: cases)
      end
    end
  end
end
