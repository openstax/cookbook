# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeReferences::V2 do

  before do
    stub_locales({
      'references': 'References'
    })
  end

  let(:book1) do
    book_containing(html:
    <<~HTML
      <div data-type="metadata" style="display: none;">
        <span data-type="revised" id="revised_copy_1">Revised</span>
        <span data-type="slug" id="slug_copy_1">Slug</span>
        <div class="authors" id="authors">Authors</div>
        <div class="publishers" id="publishers">Publishers</div>
        <div class="print-style" id="print-style">Print Style</div>
        <div class="permissions" id="permissions">Permissions</div>
        <div data-type="subject" id="subject">Subject</div>
      </div>
      <div data-type="chapter">
        <h1 data-type="document-title" id="chapTitle1">
          <span class="os-part-text">Chapter </span>
          <span class="os-number">1</span>
          <span class="os-divider"> </span>
          <span class="os-text" data-type="" itemprop="">Title Text Chapter 1</span>
        </h1>
        <div data-type="page">
          <h2 data-type='document-title'>Stuff and Things</h2>
          <section data-depth="1" id="1" class="reference">
            <h3 data-type="title">References</h3>
            <p>Prattchett, Terry: The Color of Magic</p>
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
          <h2 data-type='document-title'>Somehing</h2>
          <section data-depth="1" id="2" class="reference">
            <h3 data-type="title">References</h3>
            <p>American Psychological Association</p>
          </section>
        </div>
      </div>
    HTML
    )
  end

  it 'works' do

    described_class.new.bake(book: book1, metadata_source: metadata_element)
    expect(book1.first('.os-references-container').to_s).to match_normalized_html(
      <<~HTML
        <div class="os-eob os-references-container" data-type="composite-page" data-uuid-key=".references">
          <h1 data-type="document-title">
            <span class="os-text">References</span>
          </h1>
          <div data-type="metadata" style="display: none;">
            <h1 data-type="document-title" itemprop="name">References</h1>
            <span data-type="revised" id="revised_copy_1">Revised</span>
            <span data-type="slug" id="slug_copy_1">Slug</span>
            <div class="authors" id="authors_copy_1">Authors</div>
            <div class="publishers" id="publishers_copy_1">Publishers</div>
            <div class="print-style" id="print-style_copy_1">Print Style</div>
            <div class="permissions" id="permissions_copy_1">Permissions</div>
            <div data-type="subject" id="subject_copy_1">Subject</div>
          </div>
          <div class="os-chapter-area">
            <h2 data-type="document-title">
              <span class="os-text" data-type="" itemprop="">Title Text Chapter 1</span>
            </h2>
            <section data-depth="1" id="1" class="reference">
              <p>Prattchett, Terry: The Color of Magic</p>
            </section>
          </div>
          <div class="os-chapter-area">
            <h2 data-type="document-title">
              <span class="os-text" data-type="" itemprop="">Title Text Chapter 2</span>
            </h2>
            <section data-depth="1" id="2" class="reference">
              <p>American Psychological Association</p>
            </section>
          </div>
        </div>
      HTML
    )
  end
end
