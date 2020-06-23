module Kitchen
  module Directions

    def self.move_title_text_into_span(title)
      title.replace_children(with:
        <<~HTML
          <span data-type="" itemprop="" class="os-text">#{title.text}</span>
        HTML
      )
    end

  end
end
