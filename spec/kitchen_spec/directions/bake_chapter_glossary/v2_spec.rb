# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterGlossary::V2 do

  let(:chapter) do
    chapter_element(
      <<~HTML
        <section class='key-terms'>
          <span data-type="list">
            <span data-type="item">neurons</span>
            <span data-type="item">glia</span>
            <span data-type="item">DNA</span>
            <span data-type="item">RNA</span>
            <span data-type="item">nucleus</span>
          </span>
        </section>
      HTML
    )
  end

  it 'works' do
    expect(described_class.new.bake(chapter: chapter)).to match_snapshot_auto
  end
end
