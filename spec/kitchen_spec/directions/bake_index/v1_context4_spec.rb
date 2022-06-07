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

  let(:book_with_name_terms_without_reference) do
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
            <span xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cxlxt:index="name" cxlxt:name="Smith, Adam" id="auto_0a934714-8033-4bfb-9ebc-b83eeeb9ca1f_UUIDd3bc560b-d240-4014-72d2-a9efe31b0906">Adam Smith</span>
            <span xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cxlxt:index="name" cxlxt:name="Keynes, John Maynard">John Maynard Keynes</span>
            <span xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cmlnle:reference="Ćwierkowski, Wilhelm (1832-1920)" cxlxt:index="name" cxlxt:name="Ćwierkowskiego, Wilhelma" cxlxt:born="1832" cxlxt:died="1920">Wilhelma Ćwierkowskiego</span>
            <span xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cmlnle:reference="Chomsky, Noam (ur. 1928)" cxlxt:index="name" cxlxt:name="Chomsky, Noam" cxlxt:born="1928">Noama Chomsky'ego</span>
            <span data-type="term" index="name" name="Doe, John">John Doe</span>
          </div>
        </div>
      HTML
    )
  end

  context 'when there are name terms without reference present in pl-books' do
    it 'creates term content for such terms from name instead of reference' do
      with_locale(:pl) do
        stub_locales({
          'index': {
            'name': 'Skorowidz nazwisk'
          }
        }, locale: :pl)

        described_class.v1(book: book_with_name_terms_without_reference, types: %w[name], uuid_prefix: '.')
        expect(book_with_name_terms_without_reference.body).to match_snapshot_auto
      end
    end
  end
end
