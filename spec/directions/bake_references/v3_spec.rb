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
          #{metadata_element}
          <div data-type="document-title" id="someId1">1.1 Page</div>
          <section id="ref2" class="reference">
            <h3 data-type="title">References</h3>
            <p>Stern, P. Focus issue: getting excited about glia.</p>
          </section>
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
          #{metadata_element}
          <div data-type="document-title" id="someId2">2.1 Page</div>
          <section id="ref1" class="reference">
            <h3 data-type="title">References</h3>
            <p>Kolata, G. Severe diet doesn’t prolong life</p>
            <p id="auto_7d5ecac2-a4c4-4167-b952-c3a9bde54252_fs-id1056868">
              <a href="">link</a>
            </p>
          </section>
        </div>
      </div>
    HTML
    )
  end

  it 'works' do
    described_class.v3(book: book1, metadata_source: metadata_element)
    expect(book1.references).to match_normalized_html(
      <<~HTML
        <section id="ref2" class="reference">
          <h2 data-type="document-title" id="someId1_copy_1">
            <span class="os-number">1.1</span>
            <span class="os-divider"> </span>
            <span class="os-text" data-type="" itemprop="">1.1 Page</span>
          </h2>
          <p>Stern, P. Focus issue: getting excited about glia.</p>
        </section>
        <section id="ref1" class="reference">
          <h2 data-type="document-title" id="someId2_copy_1">
            <span class="os-number">2.1</span>
            <span class="os-divider"> </span>
            <span class="os-text" data-type="" itemprop="">2.1 Page</span>
          </h2>
          <p>Kolata, G. Severe diet doesn&#x2019;t prolong life</p>
          <p id="auto_7d5ecac2-a4c4-4167-b952-c3a9bde54252_fs-id1056868">
            <a href="">link</a>
          </p>
        </section>
      HTML
    )
  end
end
