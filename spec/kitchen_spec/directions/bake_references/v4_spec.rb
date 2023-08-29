# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeReferences do

  before do
    stub_locales({
      'eob': {
        'references': 'References'
      },
      'chapter': 'Chapter'
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
      <div data-type="chapter">
        <h1 data-type="document-title" id="chapTitle3">
          <span class="os-part-text">Chapter </span>
          <span class="os-number">3</span>
          <span class="os-divider"> </span>
          <span class="os-text" data-type="" itemprop="">Title Text Chapter 3</span>
        </h1>
        <div data-type="page">
          <h2 data-type='document-title'>Somehing else</h2>
        </div>
      </div>
    HTML
    )
  end

  it 'v4 works' do
    described_class.v4(book: book1, metadata_source: metadata_element)
    expect(book1.first('.os-references-container').to_s).to match_snapshot_auto
  end

  context 'when book uses grammatical cases' do
    it 'uses nominative case in title' do
      with_locale(:pl) do
        stub_locales({
          'eob': {
            'references': 'Bibliografia'
          },
          'chapter': {
            'nominative': 'Rozdział',
            'genitive': 'Rozdziału'
          }
        })
        described_class.v4(book: book1, metadata_source: metadata_element, cases: true)

        expect(book1.first('.os-references-container').to_s).to match_snapshot_auto
      end
    end
  end
end
