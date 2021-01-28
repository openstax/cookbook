require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeCompositePages do
  let(:book1) do
    book_containing(html:
      <<~HTML
        <div data-type="composite-page">
          <p>Text 1</p>
        </div>
        <div data-type="page">
          <p>Text 2</p>
        </div>
        <div data-type="composite-page">
          <p>Text 3</p>
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
        <div data-type="composite-page" id="composite-page-1">
          <p>Text 1</p>
        </div>
        <div data-type="page">
          <p>Text 2</p>
        </div>
        <div data-type="composite-page" id="composite-page-2">
          <p>Text 3</p>
        </div>
      HTML
    )
  end
end
