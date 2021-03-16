# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeUnitTitle::V1 do
  let(:book1) do
    book_containing(html:
      <<~HTML
        <div data-type="unit">
          <h1 data-type="document-title">First Unit Title</h1>
        </div>
        <div data-type="unit">
          <h1 data-type="document-title">Second Unit Title</h1>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.new.bake(book: book1)

    expect(book1.body.children.to_s).to match_normalized_html(
      <<~HTML
        <div data-type="unit">
          <h1 data-type="document-title">
            <span class="os-part-text">Unit </span>
            <span class="os-number">1</span>
            <span class="os-divider"> </span>
            <span data-type="" itemprop="" class="os-text">First Unit Title</span>
          </h1>
        </div>
        <div data-type="unit">
          <h1 data-type="document-title">
            <span class="os-part-text">Unit </span>
            <span class="os-number">2</span>
            <span class="os-divider"> </span>
            <span data-type="" itemprop="" class="os-text">Second Unit Title</span>
          </h1>
        </div>
      HTML
    )
  end
end
