# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeAsideInCaption do
  let(:aside_in_caption) do
    page_element(
      <<~HTML
        <div class="os-caption-container">
          <span class="os-title-label">Table </span>
          <span class="os-number">2.3</span>
          <span class="os-divider"> </span>
          <span class="os-divider"> </span>
          <span class="os-caption">Examples of Company Segments<a href="#auto_735" role="doc-noteref" epub:type="noteref">2</a><aside role="doc-footnote" epub:type="footnote" id="auto_735"><div data-type="footnote-number">2</div>GE Businesses. ...</aside></span>
        </div>
      HTML
    ).first('div.os-caption-container')
  end

  it 'works' do
    described_class.v1(caption_container: aside_in_caption)
    expect(aside_in_caption).to match_snapshot_auto
  end
end
