module Kitchen::Directions::BakePreface
  class V1
    def bake(book:)
      book.pages('$.preface').each do |page|
        page.titles.each do |title|
          title.replace_children(with:
            <<~HTML
              <span data-type="" itemprop="" class="os-text">#{title.text}</span>
            HTML
          )
          title.name = 'h1'
        end
      end
    end
  end
end
