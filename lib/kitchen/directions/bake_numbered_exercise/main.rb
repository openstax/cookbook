# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeNumberedExercise
      def self.v1(exercise:, number:)
        V1.new.bake(exercise: exercise, number: number)
      end
    end
  end
end
