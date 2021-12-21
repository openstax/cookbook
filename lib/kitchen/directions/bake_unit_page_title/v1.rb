# frozen_string_literal: true

module Kitchen::Directions::BakeUnitPageTitle
  class V1
    def bake(book:)
      book.units.each do |unit|
        @unit_title = I18n.t(:unit)
        @unit_number = unit.count_in(:book)
        unit.element_children.only(Kitchen::PageElement).each do |page|
          compose_unit_page_title(page: page, unit_title_prefix: @unit_title,
                                  unit_number: @unit_number)
        end
      end
    end

    def compose_unit_page_title(page:, unit_title_prefix:, unit_number:)
      title = page.title
      title.name = 'h2'
      title.replace_children(with:
        <<~HTML
          <span class="os-part-text">#{unit_title_prefix} </span>
          <span class="os-number">#{unit_number}</span>
          <span class="os-divider"> </span>
          <span data-type="" itemprop="" class="os-text">#{title.text}</span>
        HTML
      )
    end
  end
end
