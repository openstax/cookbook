# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeLearningObjectives
      def self.v1(chapter:)
        chapter.abstracts.each do |abstract|
          abstract.prepend(child: "<h3 data-type='title'>#{I18n.t(:learning_objectives)}</h3>")
        end
      end

      def self.v2(chapter:, add_title: true, li_numbering: false)
        learning_objectives =
          if %i[in_appendix count_only_li_in_appendix].include?(li_numbering)
            chapter.search('section.learning-objectives')
          else
            chapter.abstracts.any? ? chapter.abstracts : chapter.learning_objectives
          end

        learning_objectives.each do |abstract|
          if add_title
            abstract.prepend(child: "<h3 data-type='title'>#{I18n.t(:learning_objectives)}</h3>")
          end

          ul = abstract.first!('ul')
          ul.add_class('os-abstract')
          ul.search('li').each_with_index do |li, index|
            numbering_type =
              case li_numbering
              when :in_appendix
                "#{chapter.count_in(:book)}.#{abstract.count_in(:page)}.#{index + 1}"
              when :count_only_li
                index + 1
              when :count_only_li_in_appendix
                index + 1
              when false
                "#{chapter.count_in(:book)}.#{abstract.count_in(:chapter)}.#{index + 1}"
              end

            li.replace_children(with:
              <<~HTML
                <span class="os-abstract-token">#{numbering_type}</span>
                <span class="os-abstract-content">#{li.children}</span>
              HTML
            )
          end
        end
      end

      # Wraps & moves abstract under the corresponding chapter objective in the intro page
      def self.v3(chapter:)
        learning_objectives =
          chapter.abstracts.any? ? chapter.abstracts : chapter.learning_objectives

        abstracts = learning_objectives.map do |abstract|
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
