# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeChapterSectionExercises
      def self.v1(chapter:, options: {
        trash_title: false,
        create_title: true
      })
        options.reverse_merge!(
          trash_title: false,
          create_title: true
        )
        V1.new.bake(chapter: chapter, options: options)
      end
    end
  end
end
