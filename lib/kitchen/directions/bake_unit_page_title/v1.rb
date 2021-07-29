# frozen_string_literal: true

module Kitchen::Directions::BakeUnitPageTitle
  class V1
    def bake(book:)
      book.units.pages.each do |page|
        compose_unit_page_title(page: page)
      end
    end

    def compose_unit_page_title(page:)
      title = page.title
      title.name = 'h2'
      title.replace_children(with:
        <<~HTML
          <span data-type="" itemprop="" class="os-text">#{title.text}</span>
        HTML
      )
    end
  end
end