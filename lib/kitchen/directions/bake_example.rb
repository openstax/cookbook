# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeExample
      def self.v1(example:, number:, title_tag:)
        example.replace_children(with:
          <<~HTML
            <div class="body">
              #{example.children}
            </div>
          HTML
        )

        example.prepend(child:
          <<~HTML
            <#{title_tag} class="os-title">
              <span class="os-title-label">#{I18n.t(:example_label)} </span>
              <span class="os-number">#{number}</span>
              <span class="os-divider"> </span>
            </#{title_tag}>
          HTML
        )

        example.document
               .pantry(name: :link_text)
               .store("#{I18n.t(:example_label)} #{number}", label: example.id)

        example.titles.each { |title| title.name = 'h4' }
      end
    end
  end
end
