# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::AnswerKeyInnerContainer do

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
        chapter: book.chapters.first, metadata_source: metadata_element, append_to: append_to, solutions_plural: false
      )
    ).to match_snapshot_auto
  end

  context 'when in appendix' do
    it 'changes the title to appendix and adds appendix prefix to uuid' do
      expect(
        described_class.v1(chapter: book.pages.first, metadata_source: metadata_element, append_to: append_to, in_appendix: true)
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
          described_class.v1(chapter: book.chapters.first, metadata_source: metadata_element, append_to: append_to, cases: true)
        ).to match_normalized_html(
          <<~HTML
            <div class="os-eob os-solutions-container" data-type="composite-page" data-uuid-key=".solutions1">
              <h2 data-type="document-title">
                <span class="os-text">Rozdział 1</span>
              </h2>
              <div data-type="metadata" style="display: none;">
                <h1 data-type="document-title" itemprop="name">Rozdział 1</h1>
                <span data-type="revised" id="revised_copy_1">Revised</span>
                <span data-type="slug" id="slug_copy_1">Slug</span>
                <div class="authors" id="authors_copy_1">Authors</div>
                <div class="publishers" id="publishers_copy_1">Publishers</div>
                <div class="print-style" id="print-style_copy_1">Print Style</div>
                <div class="permissions" id="permissions_copy_1">Permissions</div>
                <div data-type="subject" id="subject_copy_1">Subject</div>
              </div>
            </div>
          HTML
        )
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
          described_class.v1(chapter: book.pages.first, metadata_source: metadata_element, append_to: append_to, in_appendix: true, cases: true)
        ).to match_normalized_html(
          <<~HTML
            <div class="os-eob os-solutions-container" data-type="composite-page" data-uuid-key=".appendixsolutions1">
              <h2 data-type="document-title">
                <span class="os-text">Dodatek A</span>
              </h2>
              <div data-type="metadata" style="display: none;">
                <h1 data-type="document-title" itemprop="name">Dodatek A</h1>
                <span data-type="revised" id="revised_copy_1">Revised</span>
                <span data-type="slug" id="slug_copy_1">Slug</span>
                <div class="authors" id="authors_copy_1">Authors</div>
                <div class="publishers" id="publishers_copy_1">Publishers</div>
                <div class="print-style" id="print-style_copy_1">Print Style</div>
                <div class="permissions" id="permissions_copy_1">Permissions</div>
                <div data-type="subject" id="subject_copy_1">Subject</div>
              </div>
            </div>
          HTML
        )
      end
    end

  end

end
