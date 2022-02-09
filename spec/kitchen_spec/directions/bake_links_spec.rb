# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeLinks do
  let(:book) do
    book_containing(html:
      <<~HTML
        <a>text</a>
        <a href='skip'>text</a>
        <a href='skip//2'>text</a>
        <a href='https://some-url'>text</a>
        <a href='http://some-url'>text</a>
        <a href='//some-url'>text</a>
      HTML
    )
  end

  it 'bakes' do
    described_class.v1(book: book)
    expect(book.body).to match_normalized_html(
      <<~HTML
        <body>
          <a>text</a>
          <a href='skip'>text</a>
          <a href='skip//2'>text</a>
          <a href="https://some-url" rel="noopener nofollow" target="_blank">text</a>
          <a href="http://some-url" rel="noopener nofollow" target="_blank">text</a>
          <a href="//some-url" rel="noopener nofollow" target="_blank">text</a>
        </body>
      HTML
    )
  end
end
