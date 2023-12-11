# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::WebPreBakeSetup do
  let(:book_pages) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <h1 data-type="document-title">Title for Ch1</h1>
          <div data-type="page" id="1234">
            <h2 data-type="document-title">Title for P1</h2>
            <div data-type="metadata">
              <h2 data-type="document-title">Metadata title P1</h2>
            </div>
            <div>page 1 content<h3>subtitle 1</h3></div>
          </div>
          <div data-type="page" id="abcd">
            <h2 data-type="document-title">Title for P2</h2>
            <div data-type="metadata">
              <h2 data-type="document-title">Metadata title P2</h2>
            </div>
            <div>page 2 content<h3>subtitle 2</h3></div>
          </div>
        </div>
      HTML
    ).pages
  end

  it 'works' do
    described_class.v1(book_pages: book_pages)
    expect(book_pages).to match_snapshot_auto
  end

  it 'works opposite WebPostBakeRestore' do
    book_pages_original = book_pages.to_s.dup # stringify to get a deep copy
    described_class.v1(book_pages: book_pages)
    expect(book_pages).not_to match_normalized_html(book_pages_original)
    Kitchen::Directions::WebPostBakeRestore.v1(book_pages: book_pages)
    expect(book_pages).to match_normalized_html(book_pages_original)
  end
end
