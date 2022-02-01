# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeListsWithPara do

  let(:book) do
    book_containing(html:
      <<~HTML
        <ol>
          <li>
            <p>blah1</p>
          </li>
          <li>
            <p>blah2</p>
          </li>
          <li>
            <p><span>random term</span> blah3</p>
          </li>
        </ol>
        <ul>
          <li>
            <p>foo1</p>
          </li>
          <li>
            <p>foo2</p>
          </li>
          <li>
            <p><span>random term2</span> foo3</p>
          </li>
        </ul>
      HTML
    )
  end

  it 'works' do
    described_class.v1(book: book)
    expect(book.body).to match_normalized_html(
      <<~HTML
        <body>
          <ol>
            <li>blah1</li>
            <li>blah2</li>
            <li><span>random term</span> blah3</li>
          </ol>
          <ul>
            <li>foo1</li>
            <li>foo2</li>
            <li><span>random term2</span> foo3</li>
          </ul>
        </body>
      HTML
    )
  end

end
