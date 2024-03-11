# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeExerciseWithTitle
      def self.v1(within:)
        # mark exercises with problem title
        problem_title = \
          'div[data-type="exercise"] > div[data-type="problem"] > [data-type="problem-title"]'

        within.search(problem_title).each do |title|
          title.parent.parent.add_class('has-problem-title')
        end
      end
    end
  end
end
