# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeIndex do

  before do
    stub_locales({
      'eob_index_symbols_group': 'Symbole',
      'index': {
        'name': 'Skorowidz nazwisk',
        'term': 'Skorowidz rzeczowy',
        'foreign': 'Skorowidz terminów obcojęzycznych'
      }
    })
  end

  let(:book2) do
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
        <div data-type="page" id="p1">
          <div data-type="document-title">Preface</div>
          <span data-type="term">foo</span>
          <span xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" data-type="term" cmlnle:reference="foo">Foo</span>
          <span xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cmlnle:reference="Chomsky, Noam (ur. 1928)" cxlxt:index="name" cxlxt:name="Chomsky, Noam" cxlxt:born="1928">Noam Chomsky</span>
          <span data-type="foreign" xml:lang="en">
            <span xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cxlxt:index="foreign">ΔE</span>
          </span>
          <span data-type="foreign" xml:lang="en">
            <span xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cxlxt:index="foreign">introspection</span>
          </span>
        </div>
        <div data-type="chapter">
          <div data-type="page" id="p2">
            <div data-type="document-title"><span>1.1</span> First Page</div>
            <span data-type="term">foo</span>
            <span xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" data-type="term" cmlnle:reference="animag">animagiem</span>
            <span data-type="term">ΔE</span>
            <span data-type="term"><em>sp</em><sup>3</sup><em>d</em><sup>2</sup> orbitals</span>
            <span xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cmlnle:reference="Wundt, Wilhelm (1832-1920)" cxlxt:index="name" cxlxt:name="Wundta, Wilhelma" cxlxt:born="1832" cxlxt:died="1920">Wilhelma Wundta</span>
            <span xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cmlnle:reference="Chomsky, Noam (ur. 1928)" cxlxt:index="name" cxlxt:name="Chomsky, Noam" cxlxt:born="1928">Noama Chomsky'ego</span>
            <span data-type="foreign" xml:lang="en">
              <span xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cxlxt:index="foreign">introspection</span>
            </span>
            <span data-type="foreign" xml:lang="en">
              <span xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cxlxt:index="foreign"><em>sp</em><sup>3</sup><em>d</em><sup>2</sup> orbitals</span>
            </span>
            <span data-type="term" reference="bar">Boo</span>
            <span data-type="term" reference="Christmas, Mary (ur. 1958)" index="name" name="Christmas, Mary" born="1958">Mary Christmas</span>
            <span data-type="foreign" xml:lang="en">
              <span data-type="term" index="foreign">train</span>
            </span>
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
          </div>
        </div>
      HTML
    )
  end

  context 'when v1 has multiple types' do
    it 'works' do
      described_class.v1(book: book2, types: %w[name term foreign], uuid_prefix: '.')
      expect(book2.body).to match_snapshot_auto
    end
  end

end
