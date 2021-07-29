# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeHandbook::V1 do
  before do
    stub_locales({
      'handbook_outline_title': 'Outline'
    })
  end

  let(:book1) do
    book_containing(html:
      <<~HTML
        <div data-type="page" class="handbook">
          <div data-type="metadata">
            <h1 data-type="document-title" itemprop="name">Handbook</h1>
          </div>
          <div data-type="document-title">Handbook</div>
          <section data-depth="1">
            <h3 id="auto_2075f23e-ddf7-4a36-84dc-7d988ec136c6_sec-001" data-type="title">Paragraphs and Transitions</h3>
            <p>Text</p>
            <section data-depth="2">
              <h4 data-type="title">Effective Paragraphs</h4>
              <p>Text</p>
              <section data-depth="3">
                <h5 data-type="title">Developing a Main Point</h5>
                <p>Text</p>
              </section>
              <section data-depth="3">
                <h5 data-type="title">Supporting Evidence and Analysis</h5>
                <p>Text</p>
              </section>
            </section>
            <section data-depth="2">
              <h4 data-type="title">Transitions</h4>
              <p>Text</p>
              <section data-depth="3">
                <h5 data-type="title">Flow</h5>
                <p>Text</p>
                <section data-depth="4">
                  <h6 data-type="title">Opening Paragraphs</h6>
                  <p>Text</p>
                </section>
              </section>
            </section>
          </section>
          <section data-depth="1">
            <h3 id="auto_2075f23e-ddf7-4a36-84dc-7d988ec136c6_sec-002" data-type="title">Another First Section Title</h3>
            <p>Text</p>
            <section data-depth="2">
              <h4 data-type="title">Second Section Title</h4>
              <p>Text</p>
              <section data-depth="3">
                <h5 data-type="title">Third Section Title</h5>
                <p>Text</p>
              </section>
            </section>
          </section>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.new.bake(book: book1, title_element: 'h1')
    expect(book1.first('div.handbook').to_s).to match_normalized_html(
      <<~HTML
        <div class="handbook" data-type="page">
        <div data-type="metadata">
          <h1 data-type="document-title" itemprop="name">Handbook</h1>
        </div>
        <h1 data-type="document-title">
          <span class="os-text" data-type="" itemprop="">Handbook</span>
        </h1>
          <div class="os-handbook-outline">
            <h3 class="os-title">Outline</h3>
            <div class="os-handbook-objective">
              <a class="os-handbook-objective" href="#auto_2075f23e-ddf7-4a36-84dc-7d988ec136c6_sec-001">
                <span class="os-part-text">H</span>
                <span class="os-number">1</span>
                <span class="os-divider">. </span>
                <span class="os-text">Paragraphs and Transitions</span>
              </a>
            </div>
            <div class="os-handbook-objective">
              <a class="os-handbook-objective" href="#auto_2075f23e-ddf7-4a36-84dc-7d988ec136c6_sec-002">
                <span class="os-part-text">H</span>
                <span class="os-number">2</span>
                <span class="os-divider">. </span>
                <span class="os-text">Another First Section Title</span>
              </a>
            </div>
          </div>
          <section data-depth="1">
            <h2 data-type="title" id="auto_2075f23e-ddf7-4a36-84dc-7d988ec136c6_sec-001">
              <span class="os-part-text">H</span>
              <span class="os-number">1</span>
              <span class="os-divider">. </span>
              <span class="os-text">Paragraphs and Transitions</span>
            </h2>
            <p>Text</p>
            <section data-depth="2">
              <h3 data-type="title">Effective Paragraphs</h3>
              <p>Text</p>
              <section data-depth="3">
                <h4 data-type="title">Developing a Main Point</h4>
                <p>Text</p>
              </section>
              <section data-depth="3">
                <h4 data-type="title">Supporting Evidence and Analysis</h4>
                <p>Text</p>
              </section>
            </section>
            <section data-depth="2">
              <h3 data-type="title">Transitions</h3>
              <p>Text</p>
              <section data-depth="3">
                <h4 data-type="title">Flow</h4>
                <p>Text</p>
                <section data-depth="4">
                  <h5 data-type="title">Opening Paragraphs</h5>
                  <p>Text</p>
                </section>
              </section>
            </section>
          </section>
          <section data-depth="1">
            <h2 data-type="title" id="auto_2075f23e-ddf7-4a36-84dc-7d988ec136c6_sec-002">
              <span class="os-part-text">H</span>
              <span class="os-number">2</span>
              <span class="os-divider">. </span>
              <span class="os-text">Another First Section Title</span>
            </h2>
            <p>Text</p>
            <section data-depth="2">
              <h3 data-type="title">Second Section Title</h3>
              <p>Text</p>
              <section data-depth="3">
                <h4 data-type="title">Third Section Title</h4>
                <p>Text</p>
              </section>
            </section>
          </section>
        </div>
      HTML
      )
  end
end
