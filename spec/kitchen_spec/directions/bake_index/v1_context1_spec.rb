# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeIndex do

  before do
    stub_locales({
      'eob_index_symbols_group': 'Symbols',
      'index': {
        'main': 'Index'
      }
    })
  end

  let(:book1) do
    book_containing(html:
      <<~HTML
        <div data-type="metadata" style="display: none;">
          <div class="authors" id="authors">Authors</div>
          <span data-type="revised" id="revised">Revised</span>
          <span data-type="slug" id="slug">Slug</span>
          <div class="publishers" id="publishers">Publishers</div>
          <div class="print-style" id="print-style">Print Style</div>
          <div class="permissions" id="permissions">Permissions</div>
          <div data-type="subject" id="subject">Subject</div>
        </div>
        <div data-type="page" class="preface" id="p1">
          <div data-type="document-title">Preface</div>
          <span data-type="term" id="replace-me-not">foo</span>
          <span data-type="term">Foo</span>
          <span data-type="term">Bar</span>
          <span data-type="term">bar</span>
          <span data-type="term">Ötzi the Iceman</span>
          <span data-type="term"><em data-effect="italics">Homo sapiens sapiens</em></span>
        </div>
        <div data-type="page" class="unit-opener" id="p7">
          <div data-type="document-title">Introduction</div>
          <span data-type="term" id="replace-me-not-5">foo</span>
          <span data-type="term">Foo</span>
          <span data-type="term">Bar</span>
        </div>
        <div data-type="chapter">
          <div data-type="page" id="p2">
            <div data-type="document-title"><span>1.1</span> First Page</div>
            <span data-type="term">foo</span>
            <span data-type="term">ΔE</span>
            <span data-type="term"><em>sp</em><sup>3</sup><em>d</em><sup>2</sup> orbitals</span>
            <span data-type="term">3-PGA</span>
            <span data-type="term"><em data-effect="italics">Homo sapiens sapiens</em></span>
          </div>
          <div data-type="composite-chapter">
            <div data-type="document-title">Chapter Review</div>
            <div data-type="composite-page">
              <h3 data-type="title">EOC Section Title</h3>
              <span data-type="term">composite page in a composite chapter</span>
            </div>
          </div>
        </div>
        <div data-type="chapter">
          <div data-type="page" id="p4"/>
          <div data-type="composite-page">
            <h2 data-type="document-title">Another EOC Section</h2>
            <span data-type="term" id="replace-me-not-2">composite page at the top level</span>
            <span data-type="term">éblahblah</span>
            <span data-type="term">5’ cap</span>
          </div>
        </div>
        <div data-type="page" class="appendix" id="p5">
          <div data-type="document-title">Appendix A</div>
          <span data-type="term" id="replace-me-not-3">foo</span>
          <span data-type="term">Foo</span>
          <span data-type="term">Bar</span>
        </div>
        <div data-type="page" class="handbook" id="p6">
          <div data-type="document-title">Handbook A</div>
          <span data-type="term" id="replace-me-not-4">foo</span>
          <span data-type="term">Foo</span>
          <span data-type="term">Bar</span>
        </div>
      HTML
    )
  end

  let(:book_with_units) do
    book_containing(html:
      <<~HTML
        <div data-type="metadata" style="display: none;">
          <div class="authors" id="authors">Authors</div>
          <span data-type="revised" id="revised">Revised</span>
          <span data-type="slug" id="slug">Slug</span>
          <div class="publishers" id="publishers">Publishers</div>
          <div class="print-style" id="print-style">Print Style</div>
          <div class="permissions" id="permissions">Permissions</div>
          <div data-type="subject" id="subject">Subject</div>
        </div>
        <div data-type="page" class="preface" id="p1">
          <div data-type="document-title">Preface</div>
          <span data-type="term" id="replace-me-not">foo</span>
          <span data-type="term">Foo</span>
          <span data-type="term">Bar</span>
          <span data-type="term">bar</span>
          <span data-type="term">Ötzi the Iceman</span>
          <span data-type="term"><em data-effect="italics">Homo sapiens sapiens</em></span>
        </div>
        <div data-type="page" class="unit-opener" id="p7">
          <div data-type="document-title">Introduction</div>
          <span data-type="term" id="replace-me-not-5">foo</span>
          <span data-type="term">Foo</span>
          <span data-type="term">Bar</span>
        </div>
        <div data-type="unit">
          <div data-type="chapter">
            <div data-type="page" id="p2">
              <div data-type="document-title"><span>1.1</span> First Page</div>
              <span data-type="term">foo</span>
              <span data-type="term">ΔE</span>
              <span data-type="term"><em>sp</em><sup>3</sup><em>d</em><sup>2</sup> orbitals</span>
              <span data-type="term">3-PGA</span>
              <span data-type="term"><em data-effect="italics">Homo sapiens sapiens</em></span>
            </div>
            <div data-type="composite-chapter">
              <div data-type="document-title">Chapter Review</div>
              <div data-type="composite-page">
                <h3 data-type="title">EOC Section Title</h3>
                <span data-type="term">composite page in a composite chapter</span>
              </div>
            </div>
          </div>
          <div data-type="chapter">
            <div data-type="page" id="p4"/>
            <div data-type="composite-page">
              <h2 data-type="document-title">Another EOC Section</h2>
              <span data-type="term" id="replace-me-not-2">composite page at the top level</span>
              <span data-type="term">éblahblah</span>
              <span data-type="term">5’ cap</span>
            </div>
          </div>
        </div>
        <div data-type="page" class="appendix" id="p5">
          <div data-type="document-title">Appendix A</div>
          <span data-type="term" id="replace-me-not-3">foo</span>
          <span data-type="term">Foo</span>
          <span data-type="term">Bar</span>
        </div>
        <div data-type="page" class="handbook" id="p6">
          <div data-type="document-title">Handbook A</div>
          <span data-type="term" id="replace-me-not-4">foo</span>
          <span data-type="term">Foo</span>
          <span data-type="term">Bar</span>
        </div>
      HTML
    )
  end

  context 'when v1 has one type' do
    it 'works' do
      described_class.v1(book: book1)
      expect(book1.first('.os-index-container').to_s).to match_snapshot_auto
    end
  end

  context 'when v1 has one type and book has units' do
    it 'works when unit numbering is disabled' do
      described_class.v1(book: book_with_units)
      expect(book_with_units.first('.os-index-container').to_s).to match_snapshot_auto
    end

    it 'works when unit numbering is enabled' do
      described_class.v1(
        book: book_with_units,
        chapters: book_with_units.units.chapters,
        numbering_options: { mode: :unit_chapter_page })
      expect(book_with_units.first('.os-index-container').to_s).to match_snapshot_auto
    end
  end

end
