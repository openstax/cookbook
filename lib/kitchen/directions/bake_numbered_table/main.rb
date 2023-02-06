# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeNumberedTable
      def self.v1(table:, number:, cases: false, move_caption_on_top: false, label_class: nil)
        V1.new.bake(table: table,
                    number: number,
                    cases: cases,
                    move_caption_on_top: move_caption_on_top,
                    label_class: label_class)
      end

      def self.v2(table:, number:, cases: false, label_class: nil)
        V2.new.bake(table: table, number: number, cases: cases, label_class: label_class)
      end
    end
  end
end
