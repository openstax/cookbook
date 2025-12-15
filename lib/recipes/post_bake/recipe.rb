# frozen_string_literal: true

POST_BAKE = Kitchen::BookRecipe.new(book_short_name: :post_bake) do |doc|
  book = doc.book

  BakeOrderHeaders.v2(within: book)

  book.search('a:not([aria-label])').each do |anchor|
    text_builder = anchor.search('.//text()').map { |t| t.text.strip }
    text_builder = text_builder.filter { |t| !t.empty? }
    text = text_builder.to_a.join(' ')
    next if text.empty?

    label = I18n.t(:generic_link_desc, link_text: text)
    anchor[:'aria-label'] = label
  end
end
