# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeCheckpoint
      def self.v1(checkpoint:, number:)
        checkpoint.wrap_children(class: 'os-note-body')

        checkpoint.prepend(child:
          <<~HTML
            <div class="os-title">
              <span class="os-title-label">#{I18n.t(:checkpoint)} </span>
              <span class="os-number">#{number}</span>
              <span class="os-divider"> </span>
            </div>
          HTML
        )

        exercise = checkpoint.exercises.first!
        exercise.search("[data-type='commentary']").trash

        problem = exercise.problem
        problem.wrap_children(class: 'os-problem-container')

        solution = exercise.solution
        return unless solution.present?

        solution.id = "#{exercise.id}-solution"
        exercise.add_class('os-hasSolution')

        solution.replace_children(with:
          <<~HTML
            <span class="os-divider"> </span>
            <a class="os-number" href="##{exercise.id}">#{number}</a>
            <div class="os-solution-container">#{solution.children}</div>
          HTML
        )

        exercise.add_class('unnumbered')
      end
    end
  end
end
