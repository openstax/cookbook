# frozen_string_literal: true
module Kitchen
  module Directions
    module BakeNumberedTable
      def self.v1(table:, number:)
        V1.new.bake(table: table, number: number)
      end
    end
  end
end
