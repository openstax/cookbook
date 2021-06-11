# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeChapterSectionExercises
      def self.v1(chapter:, trash_title: false)
        V1.new.bake(chapter: chapter, trash_title: trash_title)
      end
    end
  end
end
