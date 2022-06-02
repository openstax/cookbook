# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeExampleProblemTitle
      def self.v1(example:)
        example.exercises.each do |exercise|
          problem = exercise.problem
          problem.prepend(child:
            <<~HTML
              <h4 data-type="problem-title">
                <span class="os-title-label">#{I18n.t(:problem)}</span>
              </h4>
            HTML
          )
        end
      end
    end
  end
end
