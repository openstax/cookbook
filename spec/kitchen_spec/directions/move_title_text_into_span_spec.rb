# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::MoveTitleTextIntoSpan do

  let(:title) do
    new_element(
      <<~HTML
        <h1 data-type="document-title">foo</h1>
      HTML
    )
  end

  it 'works' do
    described_class.v1(title: title)
    expect(title).to match_snapshot_auto
  end
end
