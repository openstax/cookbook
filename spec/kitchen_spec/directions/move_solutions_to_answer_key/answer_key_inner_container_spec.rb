# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::AnswerKeyInnerContainer do

  before do
    stub_locales({
      'chapter': 'Chapter',
      'appendix': 'Appendix'
    })
  end

  let(:book) do
    book_containing(html:
      <<~HTML
        #{metadata_element}
          <div data-type="chapter">
            <div data-type="page">
              This is a page
            </div>
          </div>
      HTML
    )
  end

  let(:book_with_appendix) do
    book_containing(html:
      <<~HTML
        #{metadata_element}
        <div class ="appendix" data-type="page">
          This is a page
        </div>
      HTML
    )
  end

  let(:append_to) do
    new_element(
      <<~HTML
        <div class="heyhey"></div>
      HTML
    )
  end

  it 'v1 works for solution (plural)' do
    expect(
      described_class.v1(chapter: book.chapters.first, metadata_source: metadata_element, append_to: append_to)
    ).to match_snapshot_auto
  end

  it 'v1 works for solution (singular)' do
    expect(
      described_class.v1(
        chapter: book.chapters.first, metadata_source: metadata_element, append_to: append_to, options: { solutions_plural: false }
      )
    ).to match_snapshot_auto
  end

  context 'when in appendix' do
    it 'changes the title to appendix and adds appendix prefix to uuid' do
      expect(
        described_class.v1(chapter: book.pages.first, metadata_source: metadata_element, append_to: append_to, options: { in_appendix: true })
      ).to match_snapshot_auto
    end
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
        expect(
          described_class.v1(chapter: book.chapters.first, metadata_source: metadata_element, append_to: append_to, options: { cases: true })
        ).to match_snapshot_auto
      end
    end

    it 'uses nominative case in appendix title' do
      with_locale(:pl) do
        stub_locales({
          'appendix': {
            'nominative': 'Dodatek',
            'genitive': 'Dodatku'
          }
        })
        expect(
          described_class.v1(chapter: book.pages.first, metadata_source: metadata_element, append_to: append_to, options: { in_appendix: true, cases: true })
        ).to match_snapshot_auto
      end
    end

  end

end
