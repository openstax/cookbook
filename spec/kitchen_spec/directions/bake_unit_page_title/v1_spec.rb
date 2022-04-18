# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeUnitPageTitle::V1 do

  let(:book1) do
    book_containing(html:
      <<~HTML
        <div data-type="unit">
          <div data-type="page">
            <div data-type="document-title" id="id1">Title holder for unit</div>
          </div>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.new.bake(book: book1)

    expect(book1.body.children.to_s).to match_snapshot_auto
  end
end
