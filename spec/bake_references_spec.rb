# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeReferences do

  let(:book1) do
    book_containing(html:
    <<~HTML
      <div data-type="chapter">
        <h1 data-type="document-title" id="chapTitle1">
          <span class="os-part-text">Chapter </span>
          <span class="os-number">1</span>
          <span class="os-divider"> </span>
          <span class="os-text" data-type="" itemprop="">Title Text Chapter 1</span>
        </h1>
        <div data-type="page">
          <div data-type="metadata" style="display: none;">
            <p> I am metadata chap 1</p>
          </div>
          <p>
            <a href="#auto_12345" data-type="cite">
              <div data-type="note" class="reference" display="inline" id="auto_12345">
                Reference 1
              </div>
            </a>
            <a href="#auto_54321" data-type="cite">
              <div data-type="note" class="reference" display="inline" id="auto_54321">
                Reference 2
              </div>
            </a>
          </p>
        </div>
      </div>
      <div data-type="chapter">
        <h1 data-type="document-title" id="chapTitle2">
          <span class="os-part-text">Chapter </span>
          <span class="os-number">2</span>
          <span class="os-divider"> </span>
          <span class="os-text" data-type="" itemprop="">Title Text Chapter 2</span>
        </h1>
        <div data-type="page">
          <div data-type="metadata" style="display: none;">
            <p> I am metadata chap 2</p>
          </div>
          <p>
            <a href="#auto_6789" data-type="cite">
              <div data-type="note" class="reference" display="inline" id="auto_6789">
                Reference 3
              </div>
            </a>
          </p>
        </div>
      </div>
    HTML
    )
  end

  it 'works' do
    described_class.v1(book: book1)

    expect(book1.body).to match_normalized_html(
      <<~HTML
        <body>
          <div data-type="chapter">
            <h1 data-type="document-title" id="chapTitle1">
              <span class="os-part-text">Chapter </span>
              <span class="os-number">1</span>
              <span class="os-divider"> </span>
              <span class="os-text" data-type="" itemprop="">Title Text Chapter 1</span>
            </h1>
            <div data-type="page">
              <div data-type="metadata" style="display: none;">
                <p> I am metadata chap 1</p>
              </div>
              <p>
                <a data-type="cite" href="#auto_12345">
                  <sup class="os-citation-number">1</sup>
                </a>
                <a data-type="cite" href="#auto_54321">
                  <sup class="os-citation-number">2</sup>
                </a>
              </p>
            </div>
          </div>
          <div data-type="chapter">
            <h1 data-type="document-title" id="chapTitle2">
              <span class="os-part-text">Chapter </span>
              <span class="os-number">2</span>
              <span class="os-divider"> </span>
              <span class="os-text" data-type="" itemprop="">Title Text Chapter 2</span>
            </h1>
            <div data-type="page">
              <div data-type="metadata" style="display: none;">
                <p> I am metadata chap 2</p>
              </div>
              <p>
                <a data-type="cite" href="#auto_6789">
                  <sup class="os-citation-number">1</sup>
                </a>
              </p>
            </div>
          </div>
          <div class="os-eob os-reference-container" data-type="composite-page" data-uuid-key=".reference">
            <h1 data-type="document-title">
              <span class="os-text">References</span>
            </h1>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">References</h1>
            </div>
            <div class="os-chapter-area">
              <h2 data-type="document-title">
                <span class="os-text" data-type="" itemprop="">Title Text Chapter 1</span>
              </h2>
              <div class="reference" data-type="note" display="inline" id="auto_12345_copy_1"><span class="os-reference-number">1. </span>
                  Reference 1
                </div>
              <div class="reference" data-type="note" display="inline" id="auto_54321_copy_1"><span class="os-reference-number">2. </span>
                  Reference 2
                </div>
            </div>
            <div class="os-chapter-area">
              <h2 data-type="document-title">
                <span class="os-text" data-type="" itemprop="">Title Text Chapter 2</span>
              </h2>
              <div class="reference" data-type="note" display="inline" id="auto_6789_copy_1"><span class="os-reference-number">1. </span>
                  Reference 3
                </div>
            </div>
          </div>
        </body>
      HTML
    )
  end
end
