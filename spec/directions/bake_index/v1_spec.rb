# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeIndex::V1 do

  before do
    stub_locales({
      'eob_index_title': 'Index',
      'eob_index_symbols_group': 'Symbols'
    })
  end

  let(:a_section) { described_class::IndexSection.new(name: 'whatever') }

  let(:book1) do
    book_containing(html:
      <<~HTML
        <div data-type="metadata" style="display: none;">
          <div class="authors" id="authors">Authors</div>
          <div class="publishers" id="publishers">Publishers</div>
          <div class="print-style" id="print-style">Print Style</div>
          <div class="permissions" id="permissions">Permissions</div>
          <div data-type="subject" id="subject">Subject</div>
        </div>
        <div data-type="page" id="p1">
          <div data-type="document-title">Preface</div>
          <span data-type="term">foo</span>
          <span data-type="term">Foo</span>
          <span data-type="term">Bar</span>
          <span data-type="term">bar</span>
          <span data-type="term">Ötzi the Iceman</span>
        </div>
        <div data-type="chapter">
          <div data-type="page" id="p2">
            <div data-type="document-title"><span>1.1</span> First Page</div>
            <span data-type="term">foo</span>
            <span data-type="term">ΔE</span>
            <span data-type="term"><em>sp</em><sup>3</sup><em>d</em><sup>2</sup> orbitals</span>
            <span data-type="term">3-PGA</span>
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
            <span data-type="term">composite page at the top level</span>
            <span data-type="term">éblahblah</span>
            <span data-type="term">5’ cap</span>
          </div>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.new.bake(book: book1)

    expect(book1.first('.os-index-container').to_s).to match_normalized_html(
      <<~HTML
        <div class="os-eob os-index-container " data-type="composite-page" data-uuid-key="index">
          <h1 data-type="document-title">
            <span class="os-text">Index</span>
          </h1>
          <div data-type="metadata" style="display: none;">
            <h1 data-type="document-title" itemprop="name">Index</h1>
            <div class="authors" id="authors_copy_1">Authors</div>
            <div class="publishers" id="publishers_copy_1">Publishers</div>
            <div class="print-style" id="print-style_copy_1">Print Style</div>
            <div class="permissions" id="permissions_copy_1">Permissions</div>
            <div data-type="subject" id="subject_copy_1">Subject</div>
          </div>
          <div class="group-by">
            <span class="group-label">Symbols</span>
            <div class="os-index-item">
            <span class="os-term" group-by="Symbols">3-PGA</span>
              <a class="os-term-section-link" href="#auto_p2_term9">
                <span class="os-term-section">1.1 First Page</span>
              </a>
            </div>
            <div class="os-index-item">
              <span class="os-term" group-by="Symbols">5&#x2019; cap</span>
              <a class="os-term-section-link" href="#auto_composite_page_term4">
                <span class="os-term-section">2 Another EOC Section</span>
              </a>
            </div>
            <div class="os-index-item">
              <span class="os-term" group-by="Symbols">&#x394;E</span>
              <a class="os-term-section-link" href="#auto_p2_term7">
                <span class="os-term-section">1.1 First Page</span>
              </a>
            </div>
          </div>
          <div class="group-by">
            <span class="group-label">B</span>
            <div class="os-index-item">
              <span class="os-term" group-by="B">Bar</span>
              <a class="os-term-section-link" href="#auto_p1_term3">
                <span class="os-term-section">Preface</span>
              </a>
              <span class="os-index-link-separator">, </span>
              <a class="os-term-section-link" href="#auto_p1_term4">
                <span class="os-term-section">Preface</span>
              </a>
            </div>
          </div>
          <div class="group-by">
            <span class="group-label">C</span>
            <div class="os-index-item">
              <span class="os-term" group-by="c">composite page at the top level</span>
              <a class="os-term-section-link" href="#auto_composite_page_term2">
                <span class="os-term-section">2 Another EOC Section</span>
              </a>
            </div>
            <div class="os-index-item">
              <span class="os-term" group-by="c">composite page in a composite chapter</span>
              <a class="os-term-section-link" href="#auto_composite_page_term1">
                <span class="os-term-section">1 EOC Section Title</span>
              </a>
            </div>
          </div>
          <div class="group-by">
            <span class="group-label">E</span>
            <div class="os-index-item">
              <span class="os-term" group-by="e">&#xE9;blahblah</span>
              <a class="os-term-section-link" href="#auto_composite_page_term3">
                <span class="os-term-section">2 Another EOC Section</span>
              </a>
            </div>
          </div>
          <div class="group-by">
            <span class="group-label">F</span>
            <div class="os-index-item">
              <span class="os-term" group-by="f">foo</span>
              <a class="os-term-section-link" href="#auto_p1_term1">
                <span class="os-term-section">Preface</span>
              </a>
              <span class="os-index-link-separator">, </span>
              <a class="os-term-section-link" href="#auto_p1_term2">
                <span class="os-term-section">Preface</span>
              </a>
              <span class="os-index-link-separator">, </span>
              <a class="os-term-section-link" href="#auto_p2_term6">
                <span class="os-term-section">1.1 First Page</span>
              </a>
            </div>
          </div>
          <div class="group-by">
            <span class="group-label">O</span>
            <div class="os-index-item">
              <span class="os-term" group-by="O">&#xD6;tzi the Iceman</span>
              <a class="os-term-section-link" href="#auto_p1_term5">
                <span class="os-term-section">Preface</span>
              </a>
            </div>
          </div>
          <div class="group-by">
            <span class="group-label">S</span>
            <div class="os-index-item">
              <span class="os-term" group-by="s">sp3d2 orbitals</span>
              <a class="os-term-section-link" href="#auto_p2_term8">
                <span class="os-term-section">1.1 First Page</span>
              </a>
            </div>
          </div>
        </div>
      HTML
    )
  end

  it 'sorts terms with accent marks' do
    a_section.add_term(text_only_term('Hu'))
    a_section.add_term(text_only_term('Hückel'))
    a_section.add_term(text_only_term('Héroult'))
    a_section.add_term(text_only_term('Hunk'))

    expect(a_section.items.map(&:term_text)).to eq %w[Héroult Hu Hückel Hunk]
  end

  it 'sorts terms starting with symbols' do
    a_section.add_term(text_only_term('Δoct'))
    a_section.add_term(text_only_term('π*'))
    expect(a_section.items.map(&:term_text)).to eq %w[Δoct π*]
  end

  it 'sorts index items with superscript' do
    a_section.add_term(text_only_term('sp hybrid'))
    a_section.add_term(text_only_term('sp2 hybrid'))    # sp^2 hybrid
    a_section.add_term(text_only_term('sp3 hybrid'))    # sp^3 hybrid
    a_section.add_term(text_only_term('sp3d hybrid'))   # (sp^3)(d) hybrid
    a_section.add_term(text_only_term('sp3d2 hybrid'))  # (sp^3)(d^2) hybrid
    expect(a_section.items.map(&:term_text)).to eq [
      'sp hybrid', 'sp2 hybrid', 'sp3 hybrid', 'sp3d hybrid', 'sp3d2 hybrid'
    ]
  end

  it 'collapses the same term with different capitalization into one item with lowercase' do
    a_section.add_term(text_only_term('temperature'))
    a_section.add_term(text_only_term('Temperature'))
    expect(a_section.items.count).to eq 1
    expect(a_section.items.first.term_text).to eq 'temperature'
  end

  def text_only_term(text)
    described_class::Term.new(text: text, id: nil, group_by: nil, page_title: nil)
  end

end
