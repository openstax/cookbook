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
        <div data-type="page" id="p1">
          <div data-type="document-title">Preface</div>
          <span data-type="term">foo</span>
          <span data-type="term">Foo</span>
          <span data-type="term">Bar</span>
          <span data-type="term">bar</span>
          <span data-type="term">Ötzi the Iceman</span>
          <span data-type="term"><em data-effect="italics">Homo sapiens sapiens</em></span>
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
            <span data-type="term">composite page at the top level</span>
            <span data-type="term">éblahblah</span>
            <span data-type="term">5’ cap</span>
          </div>
        </div>
      HTML
    )
  end

  context 'when v1 has one type' do
    it 'works' do
      described_class.v1(book: book1)
      expect(book1.first('.os-index-container').to_s).to match_normalized_html(
        <<~HTML
          <div class="os-eob os-index-container" data-type="composite-page" data-uuid-key="index">
            <h1 data-type="document-title">
              <span class="os-text">Index</span>
            </h1>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Index</h1>
              <span data-type="revised" id="revised_copy_1">Revised</span>
              <span data-type="slug" id="slug_copy_1">Slug</span>
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
                <a class="os-term-section-link" href="#auto_p2_term10">
                  <span class="os-term-section">1.1 First Page</span>
                </a>
                <!--
                    -->
              </div>
              <div class="os-index-item">
                <span class="os-term" group-by="Symbols">5&#x2019; cap</span>
                <a class="os-term-section-link" href="#auto_composite_page_term4">
                  <span class="os-term-section">2 Another EOC Section</span>
                </a>
                <!--
                    -->
              </div>
              <div class="os-index-item">
                <span class="os-term" group-by="Symbols">&#x394;E</span>
                <a class="os-term-section-link" href="#auto_p2_term8">
                  <span class="os-term-section">1.1 First Page</span>
                </a>
                <!--
                    -->
              </div>
            </div>
            <div class="group-by">
              <span class="group-label">B</span>
              <div class="os-index-item">
                <span class="os-term" group-by="B">Bar</span>
                <a class="os-term-section-link" href="#auto_p1_term3">
                  <span class="os-term-section">Preface</span>
                </a>
                <!--
                    -->
                <span class="os-index-link-separator">, </span>
                <a class="os-term-section-link" href="#auto_p1_term4">
                  <span class="os-term-section">Preface</span>
                </a>
                <!--
                    -->
              </div>
            </div>
            <div class="group-by">
              <span class="group-label">C</span>
              <div class="os-index-item">
                <span class="os-term" group-by="c">composite page at the top level</span>
                <a class="os-term-section-link" href="#auto_composite_page_term2">
                  <span class="os-term-section">2 Another EOC Section</span>
                </a>
                <!--
                    -->
              </div>
              <div class="os-index-item">
                <span class="os-term" group-by="c">composite page in a composite chapter</span>
                <a class="os-term-section-link" href="#auto_composite_page_term1">
                  <span class="os-term-section">1 EOC Section Title</span>
                </a>
                <!--
                    -->
              </div>
            </div>
            <div class="group-by">
              <span class="group-label">E</span>
              <div class="os-index-item">
                <span class="os-term" group-by="e">&#xE9;blahblah</span>
                <a class="os-term-section-link" href="#auto_composite_page_term3">
                  <span class="os-term-section">2 Another EOC Section</span>
                </a>
                <!--
                    -->
              </div>
            </div>
            <div class="group-by">
              <span class="group-label">F</span>
              <div class="os-index-item">
                <span class="os-term" group-by="f">foo</span>
                <a class="os-term-section-link" href="#auto_p1_term1">
                  <span class="os-term-section">Preface</span>
                </a>
                <!--
                    -->
                <span class="os-index-link-separator">, </span>
                <a class="os-term-section-link" href="#auto_p1_term2">
                  <span class="os-term-section">Preface</span>
                </a>
                <!--
                    -->
                <span class="os-index-link-separator">, </span>
                <a class="os-term-section-link" href="#auto_p2_term7">
                  <span class="os-term-section">1.1 First Page</span>
                </a>
                <!--
                    -->
              </div>
            </div>
            <div class="group-by">
              <span class="group-label">H</span>
              <div class="os-index-item">
                <span class="os-term" group-by="H">
                  <em data-effect="italics">Homo sapiens sapiens</em>
                </span>
                <a class="os-term-section-link" href="#auto_p1_term6">
                  <span class="os-term-section">Preface</span>
                </a>
                <!--
                    -->
                <span class="os-index-link-separator">, </span>
                <a class="os-term-section-link" href="#auto_p2_term11">
                  <span class="os-term-section">1.1 First Page</span>
                </a>
                <!--
                    -->
              </div>
            </div>
            <div class="group-by">
              <span class="group-label">O</span>
              <div class="os-index-item">
                <span class="os-term" group-by="O">&#xD6;tzi the Iceman</span>
                <a class="os-term-section-link" href="#auto_p1_term5">
                  <span class="os-term-section">Preface</span>
                </a>
                <!--
                    -->
              </div>
            </div>
            <div class="group-by">
              <span class="group-label">S</span>
              <div class="os-index-item">
                <span class="os-term" group-by="s">sp3d2 orbitals</span>
                <a class="os-term-section-link" href="#auto_p2_term9">
                  <span class="os-term-section">1.1 First Page</span>
                </a>
                <!--
                    -->
              </div>
            </div>
          </div>
        HTML
      )
    end
  end

end
