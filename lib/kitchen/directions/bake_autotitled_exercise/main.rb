# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeAutotitledExercise
      def self.v1(exercise:, number: nil)
        V1.new.bake(exercise: exercise, number: number)
      end
    end
  end
end
