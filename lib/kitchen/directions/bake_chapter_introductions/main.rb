# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeChapterIntroductions
      def self.v1(book:)
        V1.new.bake(
          book: book
        )
      end

      def self.v2(
        book:,
        options: {
          strategy: :default, bake_chapter_outline: false, introduction_order: :v1,
          block_target_label: false
        }
      )
        options.reverse_merge!(
          strategy: :default,
          bake_chapter_outline: false,
          introduction_order: :v1,
          block_target_label: false
        )
        V2.new.bake(
          book: book,
          options: options,
        )
      end

      def self.bake_chapter_objectives(chapter:, strategy:)
        BakeChapterObjectives.new.bake(
          chapter: chapter,
          strategy: strategy
        )
      end

      def self.bake_chapter_outline(chapter_objectives_html:)
        BakeChapterOutline.new.bake(
          chapter_objectives_html: chapter_objectives_html
        )
      end

      def self.v1_update_selectors(something_with_selectors)
        something_with_selectors.selectors.title_in_introduction_page =
          ".intro-text > [data-type='document-title']"
      end
    end
  end
end
