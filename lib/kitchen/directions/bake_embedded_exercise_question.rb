# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeEmbeddedExerciseQuestion
      def self.v1(question:, number:, append_to:)
        append_to.append(child:
          <<~HTML
            <div data-type="exercise">
              <div data-type="problem">
                <span class="os-number">#{number}</span>
                <span class="os-divider">. </span>
                <div class="os-problem-container">#{question.cut.paste}</div>
              </div>
            </div>
          HTML
        )
      end
    end
  end
end
