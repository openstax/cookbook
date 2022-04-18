# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeInlineLists do
  let(:book) do
    book_containing(html:
      <<~HTML
        <div class="os-solution-container">
          <p>
            <span data-display="inline" data-list-type="labeled-item" data-type="list">
              <span data-type="item">1. f</span>
              <span data-type="item">2. g</span>
              <span data-type="item">3. e</span>
              <span data-type="item">4. d</span>
              <span data-type="item">5. b</span>
              <span data-type="item">6. c</span>
            </span>
          </p>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.v1(book: book)
    expect(book.body).to match_snapshot_auto
  end

end
