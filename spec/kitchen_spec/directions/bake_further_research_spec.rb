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
      ).to match_normalized_html(
        <<~HTML
          <div data-type="chapter">
            <div data-type='page' id="00" class="introduction">
              <h1 data-type="document-title" id="intro" itemprop="name">Introduction page!</h1>
            </div>
            <div data-type="page" id="01">
              <h1 data-type="document-title" id="first" itemprop="name">First Title</h1>
            </div>
            <div data-type="page" id="02">
              <h1 data-type="document-title" id="second" itemprop="name">Second Title</h1>
            </div>
            <div class="os-eoc os-further-research-container" data-type="composite-page" data-uuid-key=".further-research">
              <h2 data-type="document-title">
                <span class="os-text">Further Research</span>
              </h2>
              <div data-type="metadata" style="display: none;">
                <h1 data-type="document-title" itemprop="name">Further Research</h1>
                <span data-type="revised" id="revised_copy_1">Revised</span>
                <span data-type="slug" id="slug_copy_1">Slug</span>
                <div class="authors" id="authors_copy_1">Authors</div>
                <div class="publishers" id="publishers_copy_1">Publishers</div>
                <div class="print-style" id="print-style_copy_1">Print Style</div>
                <div class="permissions" id="permissions_copy_1">Permissions</div>
                <div data-type="subject" id="subject_copy_1">Subject</div>
              </div>
              <section class="further-research" data-element-type="further-research">
                <a href="#intro">
                  <h3 data-type="document-title" id="intro_copy_1">
                    <span class="os-text" data-type="" itemprop="">Introduction page!</span>
                  </h3>
                </a>
                <p>This moves too!</p>
              </section>
              <section class="further-research" data-element-type="further-research">
                <a href="#first">
                  <h3 data-type="document-title" id="first_copy_1">
                    <span class="os-number">1.1</span>
                    <span class="os-divider"> </span>
                    <span class="os-text" data-type="" itemprop="">First Title</span>
                  </h3>
                </a>
                <p>Many paragraphs provide a good summary.</p>
              </section>
              <section class="further-research" data-element-type="further-research">
                <a href="#second">
                  <h3 data-type="document-title" id="second_copy_1">
                    <span class="os-number">1.2</span>
                    <span class="os-divider"> </span>
                    <span class="os-text" data-type="" itemprop="">Second Title</span>
                  </h3>
                </a>
                <p>Ooh, it's another bit of text.</p>
              </section>
            </div>
          </div>
        HTML
      )
    end
  end
end
