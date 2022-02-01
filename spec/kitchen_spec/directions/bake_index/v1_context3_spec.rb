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

  let(:book_with_polish_letters) do
    book_containing(html:
      <<~HTML
        <div data-type="metadata" style="display: none;">
          <span data-type="revised" id="revised">Revised</span>
          <span data-type="slug" id="slug">Slug</span>
          <div class="authors" id="authors">Authors</div>
          <div class="publishers" id="publishers">Publishers</div>
          <div class="print-style" id="print-style">Print Style</div>
          <div class="permissions" id="permissions">Permissions</div>
          <div data-type="subject" id="subject">Subject</div>
        </div>
        <div data-type="chapter">
          <div data-type="page" id="p1">
            <div data-type="document-title"><span>1.1</span> First Page</div>
            <span data-type="term">czosnek</span>
            <span data-type="term">ćma</span>
            <span xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" data-type="term" cmlnle:reference="ćwiczenie">ćwiczeniu</span>
            <span xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cmlnle:reference="Ćwierkowski, Wilhelm (1832-1920)" cxlxt:index="name" cxlxt:name="Ćwierkowskiego, Wilhelma" cxlxt:born="1832" cxlxt:died="1920">Wilhelma Ćwierkowskiego</span>
            <span xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cmlnle:reference="Chomsky, Noam (ur. 1928)" cxlxt:index="name" cxlxt:name="Chomsky, Noam" cxlxt:born="1928">Noama Chomsky'ego</span>
          </div>
        </div>
      HTML
    )
  end

  context 'when v1 has multiple types in polish books' do
    it 'works' do
      with_locale(:pl) do
        stub_locales({
          'index': {
            'name': 'Skorowidz nazwisk',
            'term': 'Skorowidz rzeczowy'
          }
        }, locale: :pl)

        described_class.v1(book: book_with_polish_letters, types: %w[name term], uuid_prefix: '.')
        expect(book_with_polish_letters.search('.os-eob').to_s).to match_normalized_html(
          <<~HTML
            <div class="os-eob os-index-name-container" data-type="composite-page" data-uuid-key=".index-name">
              <h1 data-type="document-title">
                <span class="os-text">Skorowidz nazwisk</span>
              </h1>
              <div data-type="metadata" style="display: none;">
                <h1 data-type="document-title" itemprop="name">Skorowidz nazwisk</h1>
                <span data-type="revised" id="revised_copy_1">Revised</span>
                <span data-type="slug" id="slug_copy_1">Slug</span>
                <div class="authors" id="authors_copy_1">Authors</div>
                <div class="publishers" id="publishers_copy_1">Publishers</div>
                <div class="print-style" id="print-style_copy_1">Print Style</div>
                <div class="permissions" id="permissions_copy_1">Permissions</div>
                <div data-type="subject" id="subject_copy_1">Subject</div>
              </div>
              <div class="group-by">
                <span class="group-label">C</span>
                <div class="os-index-item">
                  <span class="os-term" group-by="C">Chomsky, Noam (ur. 1928)</span>
                  <a class="os-term-section-link" href="#auto_p1_term5">
                    <span class="os-term-section">1.1 First Page</span>
                  </a>
                  <!--
                      -->
                </div>
              </div>
              <div class="group-by">
                <span class="group-label">Ć</span>
                <div class="os-index-item">
                  <span class="os-term" group-by="Ć">Ćwierkowski, Wilhelm (1832-1920)</span>
                  <a class="os-term-section-link" href="#auto_p1_term4">
                    <span class="os-term-section">1.1 First Page</span>
                  </a>
                  <!--
                      -->
                </div>
              </div>
            </div>
            <div class="os-eob os-index-term-container" data-type="composite-page" data-uuid-key=".index-term">
              <h1 data-type="document-title">
                <span class="os-text">Skorowidz rzeczowy</span>
              </h1>
              <div data-type="metadata" style="display: none;">
                <h1 data-type="document-title" itemprop="name">Skorowidz rzeczowy</h1>
                <span data-type="revised" id="revised_copy_2">Revised</span>
                <span data-type="slug" id="slug_copy_2">Slug</span>
                <div class="authors" id="authors_copy_2">Authors</div>
                <div class="publishers" id="publishers_copy_2">Publishers</div>
                <div class="print-style" id="print-style_copy_2">Print Style</div>
                <div class="permissions" id="permissions_copy_2">Permissions</div>
                <div data-type="subject" id="subject_copy_2">Subject</div>
              </div>
              <div class="group-by">
                <span class="group-label">C</span>
                <div class="os-index-item">
                  <span class="os-term" group-by="c">czosnek</span>
                  <a class="os-term-section-link" href="#auto_p1_term1">
                    <span class="os-term-section">1.1 First Page</span>
                  </a>
                  <!--
                      -->
                </div>
              </div>
              <div class="group-by">
                <span class="group-label">Ć</span>
                <div class="os-index-item">
                  <span class="os-term" group-by="ć">ćma</span>
                  <a class="os-term-section-link" href="#auto_p1_term2">
                    <span class="os-term-section">1.1 First Page</span>
                  </a>
                  <!--
                      -->
                </div>
                <div class="os-index-item">
                  <span class="os-term" group-by="ć">ćwiczenie</span>
                  <a class="os-term-section-link" href="#auto_p1_term3">
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
end
