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

  let(:book_with_chapter_modules_with_titles_children) do
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
          <div data-type="document-title" id="someId1"><em data-effect="italics">Italics</em> & not italics with <sub>subscript</sub> and <sup>superscript</sup> text 1.1 Page</div>
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

  it 'v3 works' do
    described_class.v3(book: book1, metadata_source: metadata_element)
    book1.references.each
    expect(normalized_xml_doc_string(book1.references)).to match_snapshot_auto
  end

  context 'v3 when book contains modules with titles elements children' do
    it 'keeps the modules titles children while creating section title' do
      described_class.v3(book: book_with_chapter_modules_with_titles_children, metadata_source: metadata_element)
      book_with_chapter_modules_with_titles_children.references.each
      expect(normalized_xml_doc_string(book_with_chapter_modules_with_titles_children.references)).to match_snapshot_auto
    end
  end
end
