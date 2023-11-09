# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeRexWrappers::V1 do

  let(:book_with_pages) do
    book_containing(html:
      <<~HTML
        <div data-type="page">
          <h1>Page 1</h2>
        </div>
        <div data-type="composite-page">
          <h1>Page 1</h2>
        </div>
        <div data-type="chapter">
          <div data-type="page">
            <h1>Page 1</h2>
          </div>
          <div data-type="composite-page">
            <h1>Page 1</h2>
          </div>
        </div>
      HTML
    )
  end

  it 'adds attribute correctly' do
    described_class.new.bake(book: book_with_pages)
    expect(book_with_pages).to match_snapshot_auto
  end
end
