# frozen_string_literal: true

module Kitchen::Directions::BakeUnitTitle
  class V1
    def bake(book:)
      book.units.each do |unit|
        compose_unit_title(unit: unit)
      end
    end

    def compose_unit_title(unit:)
      heading = unit.title
      heading.replace_children(with:
        <<~HTML
          <span class="os-part-text">#{I18n.t(:unit)} </span>
          <span class="os-number">#{unit.count_in(:book)}</span>
          <span class="os-divider"> </span>
          <span data-type="" itemprop="" class="os-text">#{heading.text}</span>
        HTML
      )
    end
  end
end
