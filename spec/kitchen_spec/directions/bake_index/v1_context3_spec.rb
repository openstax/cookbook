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
        expect(book_with_polish_letters.search('.os-eob').to_s).to match_snapshot_auto
      end
    end
  end
end
