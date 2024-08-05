# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeHiddenSolutionsWeb do
  let(:content) do
    book_containing(html:
      <<~HTML
        <div data-type="exercise" class="unnumbered">
          <div data-type="problem" />
          <div data-type="solution" abc="123">
            <span>solution content</span>
          </div>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.v1(book_pages: content)
    expect(content).to match_snapshot_auto
  end
end
