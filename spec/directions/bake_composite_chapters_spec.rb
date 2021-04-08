# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeCompositeChapters do
  let(:book1) do
    book_containing(html:
      <<~HTML
        <div data-type="composite-chapter">
          <p data-type="document-title">Text 1</p>
        </div>
        <div data-type="chapter">
          <h1 data-type="document-title">Text 2</h1>
        </div>
        <div data-type="composite-chapter">
          <h2 data-type="document-title">Text 3</h2>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.v1(book: book1)
    expect(
      book1.body.children.to_s
    ).to match_normalized_html(
      <<~HTML
        <div data-type="composite-chapter">
          <p data-type="document-title" id="composite-chapter-1">Text 1</p>
        </div>
        <div data-type="chapter">
          <h1 data-type="document-title">Text 2</h1>
        </div>
        <div data-type="composite-chapter">
          <h2 data-type="document-title" id="composite-chapter-2">Text 3</h2>
        </div>
      HTML
    )
  end
end
