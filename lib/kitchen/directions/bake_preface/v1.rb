# frozen_string_literal: true

module Kitchen::Directions::BakePreface
  class V1
    def bake(book:, title_element:)
      book.pages('$.preface').each do |page|
        page.search('div[data-type="description"], div[data-type="abstract"]').each(&:trash)
        page.titles.each do |title|
          title.replace_children(with:
            <<~HTML
              <span data-type="" itemprop="" class="os-text">#{title.text}</span>
            HTML
          )
          title.name = title_element
        end
      end
    end
  end
end
