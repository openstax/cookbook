# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeStepwise
      def self.v1(book:)
        book.search('ol.stepwise').each do |ol|
          ol.remove_class('stepwise')
          ol.add_class('os-stepwise')

          ol.search('li').each_with_index do |li, ii|
            li.replace_children(with:
              <<~HTML
                <span class="os-stepwise-content">#{li.children}</span>
              HTML
            )
            li.prepend(child:
              <<~HTML
                <span class="os-stepwise-token">#{I18n.t(:stepwise_step_label)} #{ii + 1}. </span>
              HTML
            )
          end
        end
      end
    end
  end
end
