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

    expect(book1.body.children.to_s).to match_snapshot_auto
  end
end
