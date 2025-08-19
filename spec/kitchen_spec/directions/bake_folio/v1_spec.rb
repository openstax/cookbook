# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeFolio do
  let(:book) do
    book_containing(html:
      <<~HTML
        <div class='hi'>Howdy</div>
      HTML
    )
  end

  let(:book_with_folio) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <h1 data-type="document-title">
            <span class="os-text">Chapter title</span>
          </h1>
          <div data-type="page" class="introduction">
            <h2 data-type="document-title">
              <span class="os-text">Introduction title</span>
            </h2>
          </div>
          <div data-type="page">
            <h2 data-type="document-title">
              <span class="os-text">Module title</span>
            </h2>
          </div>
          <div data-type="composite-page" class="os-eoc">
            <h2 data-type="document-title">
              <span class="os-text">Eoc title</span>
            </h2>
          </div>
        </div>
        <div data-type="page" class="appendix">
          <h1 data-type="document-title">
            <span class="os-text">Appendix title</span>
          </h1>
        </div>
        <div data-type="composite-chapter" class="os-eob os-solutions-container">
          <h1 data-type="document-title">
            <span class="os-text">Answer Key title</span>
          </h1>
          <div data-type="composite-page" class="os-eob os-solutions-container">
            <h2 data-type="document-title">
              <span class="os-text">Chapter title</span>
            </h2>
          </div>
        </div>
        <div data-type="composite-page" class="os-eob">
          <h1 data-type="document-title">
            <span class="os-text">Index title</span>
          </h1>
        </div>
      HTML
    )
  end

  let(:book_with_folio_and_units) do
    book_containing(html:
      <<~HTML
        <div data-type="unit">
          <div data-type="chapter">
            <h1 data-type="document-title">
              <span class="os-text">Chapter title</span>
            </h1>
            <div data-type="page" class="introduction">
              <h2 data-type="document-title">
                <span class="os-text">Introduction title</span>
              </h2>
            </div>
            <div data-type="page">
              <h2 data-type="document-title">
                <span class="os-text">Module title</span>
              </h2>
            </div>
            <div data-type="composite-page" class="os-eoc">
              <h2 data-type="document-title">
                <span class="os-text">Eoc title</span>
              </h2>
            </div>
          </div>
        </div>
        <div data-type="page" class="appendix">
          <h1 data-type="document-title">
            <span class="os-text">Appendix title</span>
          </h1>
        </div>
        <div data-type="composite-chapter" class="os-eob os-solutions-container">
          <h1 data-type="document-title">
            <span class="os-text">Answer Key title</span>
          </h1>
          <div data-type="composite-page" class="os-eob os-solutions-container">
            <h2 data-type="document-title">
              <span class="os-text">Chapter title</span>
            </h2>
          </div>
        </div>
        <div data-type="composite-page" class="os-eob">
          <h1 data-type="document-title">
            <span class="os-text">Index title</span>
          </h1>
        </div>
      HTML
    )
  end

  describe 'folio pdf translations' do
    it 'works in english' do
      described_class.v1(book: book)
      expect(book).to match_snapshot_auto
    end

    it 'works in spanish' do
      with_locale(:es) do
        described_class.v1(book: book)
      end

      expect(book).to match_snapshot_auto
    end

    context 'when book uses new approach' do
      it 'creates folio paras' do
        described_class.v1(book: book_with_folio, options: { new_approach: true })
        expect(book_with_folio).to match_snapshot_auto
      end

      it 'works with units when unit numbering disabled' do
        described_class.v1(
          book: book_with_folio_and_units,
          chapters: book_with_folio_and_units.units.chapters,
          options: { new_approach: true, numbering_options: { mode: :chapter_page } })
        expect(book_with_folio_and_units).to match_snapshot_auto
      end

      it 'works with units when unit numbering enabled' do
        described_class.v1(
          book: book_with_folio_and_units,
          chapters: book_with_folio_and_units.units.chapters,
          options: { new_approach: true, numbering_options: { mode: :unit_chapter_page } })
        expect(book_with_folio_and_units).to match_snapshot_auto
      end
    end
  end
end
