# frozen_string_literal: true
@solution_2 = Kitchen::BookRecipe.new do |doc|
  book = doc.book

  book.chapters.each do |chapter|
    chapter.prepend(child: <<~HTML
      <h1 data-type="document-title">Chapter #{chapter.count_in(:book)}</h1>
    HTML
    )

    chapter.pages.each do |page|
      page.title
          .set(:name, 'h2')
          .prepend(child: "#{chapter.count_in(:book)}.#{page.count_in(:chapter)} ")
    end
  end
end
