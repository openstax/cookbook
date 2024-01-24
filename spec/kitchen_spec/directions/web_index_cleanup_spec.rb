# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::WebIndexCleanup do
  let(:book_pages) do
    book_containing(html:
      <<~HTML
        <div class="os-eob os-index-container" data-type="composite-page">
          <h1 data-type="document-title">
            <span class="os-text">Index</span>
          </h1>
          <div class="group-by">
            <span class="group-label">A</span>
            <div class="os-index-item">
              <span class="os-term" group-by="A">Ainsworth</span>
              <a class="os-term-section-link" href="#term-1"><span class="os-term-section">2.1 Identity</span></a>
              <span class="os-index-link-separator">, </span>
              <a class="os-term-section-link" href="#term-2"><span class="os-term-section">1.1 Physical Growth</span></a>
            </div>
            <div class="os-index-item">
              <span class="os-term" group-by="A">Alzhiemer’s</span>
              <a class="os-term-section-link" href="#term-3"><span class="os-term-section">1.1 Physical Growth</span></a>
              <span class="os-index-link-separator">, </span>
              <a class="os-term-section-link" href="#term-4"><span class="os-term-section">1.1 Physical Growth</span></a>
            </div>
          </div>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.v1(book_pages: book_pages)
    expect(book_pages.to_s).to match_snapshot_auto
  end
end
