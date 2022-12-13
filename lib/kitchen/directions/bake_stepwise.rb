# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeStepwise
      def self.v1(book:)
        # Block-level elements: https://developer.mozilla.org/en-US/docs/Web/HTML/Block-level_elements
        block_level = %w[
          address
          article
          aside
          blockquote
          details
          dialog
          dd
          div
          dl
          dt
          fieldset
          figcaption
          figure
          footer
          form
          h1
          h2
          h3
          h4
          h5
          h6
          header
          hgroup
          hr
          li
          main
          nav
          ol
          p
          pre
          section
          table
          ul
        ]
        book.search('ol.stepwise').each do |ol|
          ol.remove_class('stepwise')
          ol.add_class('os-stepwise')

          ol.search('> li').each_with_index do |li, ii|
            # If the list item contains block-level elements then wrap in a div
            tag = if li.search(block_level.join(',')).to_a.length.positive?
                    'div'
                  else
                    'span'
                  end
            li.wrap_children(tag, class: 'os-stepwise-content')
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
