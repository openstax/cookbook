# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeNumberedTable
      def self.v1(table:, number:, always_caption: false, cases: false)
        V1.new.bake(table: table, number: number, always_caption: always_caption, cases: cases)
      end

      def self.v2(table:, number:, cases: false)
        V2.new.bake(table: table, number: number, cases: cases)
      end
    end
  end
end
