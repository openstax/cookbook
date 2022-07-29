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

  let(:book_with_terms_with_invalid_index_values) do
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
            <span data-type="term" xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" cxlxt:index="default">czosnek</span>
            <span data-type="term">czas</span>
            <span data-type="term" xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" cxlxt:index="czarownica">czarownica</span>
            <span data-type="foreign" xml:lang="en">
              <span xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cxlxt:index="foreign">introspection</span>
            </span>
            <span xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cxlxt:index="name" cxlxt:name="Chomsky, Noam" cxlxt:born="1928">Noam Chomsky</span>
          </div>
        </div>
      HTML
    )
  end

  context 'when v1 has multiple types and book contains terms with indexes with invalid values' do
    it 'adds term to index of particular type depending on its index value (terms with invalid values are added to Skorowidz rzeczowy)' do
      described_class.v1(book: book_with_terms_with_invalid_index_values, types: %w[name term foreign], uuid_prefix: '.')
      expect(book_with_terms_with_invalid_index_values.search('.os-eob').to_s).to match_snapshot_auto
    end
  end

  context 'when book contains terms with indexes with invalid values' do
    it 'logs a warning with term name' do
      allow($stdout).to receive(:puts)
      expect($stdout).to receive(:puts).with("warning! term with invalid index value: 'czosnek id=auto_p1_term1'")
      expect($stdout).to receive(:puts).with("warning! term with invalid index value: 'czarownica id=auto_p1_term3'")
      described_class.v1(book: book_with_terms_with_invalid_index_values, types: %w[name term foreign], uuid_prefix: '.'
      )
    end
  end
end
