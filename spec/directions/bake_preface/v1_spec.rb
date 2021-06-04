# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakePreface::V1 do
  let(:book1) do
    book_containing(html:
      <<~HTML
        <div data-type="page" class="preface">
          <div data-type="document-title">Preface</div>
          <div data-type="metadata">
            <div data-type="document-title">Preface</div>
          </div>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.new.bake(book: book1, title_element: 'h1')

    expect(book1.body).to match_normalized_html(
      <<~HTML
        <body>
          <div class="preface" data-type="page">
            <h1 data-type="document-title">
              <span class="os-text" data-type="" itemprop="">Preface</span>
            </h1>
            <div data-type="metadata">
              <h1 data-type="document-title">
                <span class="os-text" data-type="" itemprop="">Preface</span>
              </h1>
            </div>
          </div>
        </body>
      HTML
    )
  end
end
