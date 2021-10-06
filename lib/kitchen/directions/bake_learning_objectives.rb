# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeLearningObjectives
      def self.v1(chapter:)
        chapter.abstracts.each do |abstract|
          abstract.prepend(child: "<h3 data-type='title'>#{I18n.t(:learning_objectives)}</h3>")
        end
      end

      def self.v2(chapter:, add_title: true)
        learning_objectives =
          chapter.abstracts.any? ? chapter.abstracts : chapter.learning_objectives

        learning_objectives.each do |abstract|
          if add_title
            abstract.prepend(child: "<h3 data-type='title'>#{I18n.t(:learning_objectives)}</h3>")
          end

          ul = abstract.first!('ul')
          ul.add_class('os-abstract')
          ul.search('li').each_with_index do |li, index|
            li.replace_children(with:
              <<~HTML
                <span class="os-abstract-token">#{chapter.count_in(:book)}.#{abstract.count_in(:chapter)}.#{index + 1}</span>
                <span class="os-abstract-content">#{li.children}</span>
              HTML
            )
          end
        end
      end

      # Wraps & moves abstract under the corresponding chapter objective in the intro page
      def self.v3(chapter:)
        abstracts = chapter.abstracts.map do |abstract|
          abstract.wrap('<div class="learning-objective">')
          abstract.parent
        end

        chapter.introduction_page.search('div.os-chapter-objective') \
               .each_with_index do |objective, index|
          objective.append(child: abstracts[index].cut.paste)
        end
      end
    end
  end
end
