# frozen_string_literal: true

WEB_RECIPE = Kitchen::BookRecipe.new(book_short_name: :web) do |doc, resources|
  include Kitchen::Directions

  # Setup
  book = doc.book
  book_pages = book.search_with(
    Kitchen::PageElementEnumerator, Kitchen::CompositePageElementEnumerator
  )
  WebPreBakeSetup.v1(book_pages: book_pages)

  # Web directions
  BakeImages.v1(book_pages: book_pages, resources: resources)
  book_pages.each do |page_or_composite|
    BakeOrderHeaders.v1(within: page_or_composite)
  end
  WebIndexCleanup.v1(book_pages: book_pages)

  # Restore
  WebPostBakeRestore.v1(book_pages: book_pages)
end
