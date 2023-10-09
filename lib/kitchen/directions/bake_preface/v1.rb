# frozen_string_literal: true

module Kitchen::Directions::BakePreface
  class V1
    def bake(book:, title_element:, cases: false)
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
        page.figures(only: :figure_to_number?).each do |figure|
          Kitchen::Directions::BakeFigure.v1(figure: figure,
                                             number: figure.count_in(:page).to_s,
                                             cases: cases)
        end
      end
    end
  end
end
