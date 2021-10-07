# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeAutotitledExercise
      def self.v1(exercise:, number: nil)
        V1.new.bake(exercise: exercise, number: number)
      end

      def self.v2(exercise:, title:)
        V2.new.bake(exercise: exercise, title: title)
      end
    end
  end
end
