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
    described_class.new.bake(book: book1)

    expect(book1).to match_normalized_html(
      <<~HTML
        <html xmlns="http://www.w3.org/1999/xhtml">
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
        </html>
      HTML
    )
  end
end
