# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterReferences::V2 do

  before do
    stub_locales({
      'eoc': {
        'references': 'Endnotes'
      }
    })
  end

  let(:chapter) do
    chapter_element(
      <<~HTML
        <div data-type="page" id="page1">
          <h1 data-type='document-title'>Introduction to Sociology</h1>
          <p>Some text
            <a href="#something" data-type="cite" id="some-id">
              <div data-type="note" class="delete-me">
                <!-- no-selfclose -->
              </div>
            </a>
          </p>
          <section data-depth="1" id="1" class="reference">
            <h3 data-type="title">Endnotes</h3>
            <div data-type="note" id="note1">
              <a href="#note1">
                <span>1</span>
              </a>
              <span>Victoria Knowles, “What’s the Difference Between CSR and Sustainability?”</span>
            </div>
          </section>
        </div>
        <div data-type="page" id="page2">
          <h1 data-type='document-title'>What Is Sociology?</h1>
          <p>Some text
            <a href="#something2" data-type="cite" id="some-id2">
              <div data-type="note" class="delete-me">
                <!-- no-selfclose -->
              </div>
            </a>
          </p>
          <section data-depth="1" id="2" class="reference">
            <h3 data-type="title">Endnotes</h3>
            <div data-type="note" id="note2">
              <a href="#note2">
                <span>2</span>
              </a>
              <span>Abercrombie, Nicholas, Stephen Hill, and Bryan S. Turner. 2000. The Penguin Dictionary of Sociology. London: Penguin.</span>
            </div>
          </section>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.new.bake(chapter: chapter, metadata_source: metadata_element)
    expect(chapter).to match_normalized_html(
      <<~HTML
        <div data-type="chapter">
          <div data-type="page" id="page1">
            <h1 data-type='document-title'>Introduction to Sociology</h1>
            <p>Some text
            <a href="#something" data-type="cite" id="page1-endNote1"><sup class="os-end-note-number">1</sup></a>
          </p>
          </div>
          <div data-type="page" id="page2">
            <h1 data-type="document-title">What Is Sociology?</h1>
            <p>Some text
            <a href="#something2" data-type="cite" id="page2-endNote2"><sup class="os-end-note-number">2</sup></a>
          </p>
          </div>
          <div class="os-eoc os-references-container" data-type="composite-page" data-uuid-key=".references">
            <h2 data-type="document-title">
              <span class="os-text">Endnotes</span>
            </h2>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Endnotes</h1>
              <span data-type="revised" id="revised_copy_1">Revised</span>
              <span data-type="slug" id="slug_copy_1">Slug</span>
              <div class="authors" id="authors_copy_1">Authors</div>
              <div class="publishers" id="publishers_copy_1">Publishers</div>
              <div class="print-style" id="print-style_copy_1">Print Style</div>
              <div class="permissions" id="permissions_copy_1">Permissions</div>
              <div data-type="subject" id="subject_copy_1">Subject</div>
            </div>
            <section data-depth="1" id="1" class="reference">
              <div data-type="note" id="note1">
                <a href="#page1-endNote1">
                  <span>1.</span>
                </a>
                <span>Victoria Knowles, “What’s the Difference Between CSR and Sustainability?”</span>
              </div>
            </section>
            <section data-depth="1" id="2" class="reference">
              <div data-type="note" id="note2">
                <a href="#page2-endNote2">
                  <span>2.</span>
                </a>
                <span>Abercrombie, Nicholas, Stephen Hill, and Bryan S. Turner. 2000. The Penguin Dictionary of Sociology. London: Penguin.</span>
              </div>
            </section>
          </div>
        </div>
    HTML
    )
  end
end
