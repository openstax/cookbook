# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterTitle::V1 do
  before do
    stub_locales({
      'chapter': 'Chapter'
    })
  end

  let(:book1) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <h1>dummy</h1>
          <h1 data-type="document-title">chapter 1</h1>
        </div>
        <div data-type="chapter">
          <h1>dummy</h1>
          <h1 data-type="document-title">chapter 2</h1>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.new.bake(book: book1)

    expect(book1.body.children.to_s).to match_snapshot_auto
  end

  context 'when book uses grammatical cases' do
    it 'uses nominative case in title' do
      with_locale(:pl) do
        stub_locales({
          'chapter': {
            'nominative': 'Rozdział',
            'genitive': 'Rozdziału'
          }
        })
        described_class.new.bake(book: book1, cases: true)

        expect(book1.body.children.to_s).to match_snapshot_auto
      end
    end
  end
end
