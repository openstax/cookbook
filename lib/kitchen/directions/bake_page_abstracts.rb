# frozen_string_literal: true

module Kitchen
  module Directions
    # Adds learning objectives header to abstracts
    module BakePageAbstracts
      def self.v1(chapter:)
        chapter.abstracts.each do |abstract|
          abstract.prepend(child: "<h3 data-type='title'>#{I18n.t(:learning_objectives)}</h3>")
        end
      end
    end
  end
end
