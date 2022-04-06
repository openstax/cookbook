# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeFurtherResearch do

  before do
    stub_locales({
      'eoc': {
        'further-research': 'Further Research'
      }
    })
  end

  let(:chapter) do
    chapter_element(
      <<~HTML
        <div data-type='page' id="00" class="introduction">
          <h1 data-type="document-title" itemprop="name" id="intro">Introduction page!</h1>
          <section class="further-research" data-element-type="further-research">
              <h3 data-type='title'>Kitchen Prep</h3>
              <p>This moves too!</p>
          </section>
        </div>
        <div data-type='page' id ="01">
          <h1 data-type="document-title" itemprop="name" id="first">First Title</h1>
          <section class="further-research" data-element-type="further-research">
              <h3 data-type='title'>Roasting</h3>
              <p>Many paragraphs provide a good summary.</p>
          </section>
        </div>
        <div data-type='page' id="02">
          <h1 data-type="document-title" itemprop="name" id="second">Second Title</h1>
          <section class="further-research" data-element-type="further-research">
              <h3 data-type='title'>Frying</h3>
              <p>Ooh, it's another bit of text.</p>
          </section>
        </div>
      HTML
    )
  end

  context 'when v1 is called on a chapter' do
    it 'works' do
      metadata = metadata_element.append(child:
        <<~HTML
          <div data-type="random" id="subject">Random - should not be included</div>
        HTML
      )
      described_class.v1(chapter: chapter, metadata_source: metadata)
      expect(
        chapter
      ).to match_snapshot_auto
    end
  end
end
