module Kitchen
  module Directions
    module BakeExample

      def self.v1(example:, number:)
        example.replace_children(with:
          <<~HTML
            <div class="body">
              #{example.children}
            </div>
          HTML
        )

        example.prepend(child:
          <<~HTML
            <h3 class="os-title">
              <span class="os-title-label">#{I18n.t(:example)} </span>
              <span class="os-number">#{number}</span>
              <span class="os-divider"> </span>
            </h3>
          HTML
        )

        example.document.pantry(name: :link_text).store "Example #{number}", label: example.id

        example.titles.each {|title| title.name = "h4"}
      end

    end
  end
end
