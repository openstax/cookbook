# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeNonIntroductionPages do

  before do
    stub_locales({
      'module': 'Podrozdział'
    })
  end

  let(:chapter) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="metadata" style="display: none;">
            <div class="description" itemprop="description" data-type="description">
              <ul>
                <li>Use functional notation to evaluate a function.</li>
              </ul>
            </div>
          </div>
          <div data-type="document-title" id="anId">Review of Functions</div>
        HTML
      )
    ).chapters.first
  end

  let(:chapter2) do
    book_containing(html:
        <<~HTML
          <div data-type="chapter">
            <div data-type="page" id="page_123">
              <div data-type="document-title" id="auto_123_0">Review of Functions</div>
            </div>
          </div>
        HTML
    ).chapters.first
  end

  let(:chapter3) do
    book_containing(html:
        <<~HTML
          <div data-type="chapter">
            <div data-type="page" id="page_1234">
              <div data-type="document-title" id="auto_1234_0"><em data-effect="italics">Italics</em> & not italics with <sub>subscript</sub> and <sup>superscript</sup> text</div>
            </div>
          </div>
        HTML
    ).chapters.first
  end

  let(:units) do
    book_containing(html:
        <<~HTML
          <div data-type="unit">
            <div data-type="chapter">
              <div data-type="page" id="page_1">
                <div data-type="document-title" id="auto_1234_0"><em data-effect="italics">Italics</em> & not italics with <sub>subscript</sub> and <sup>superscript</sup> text</div>
              </div>
              <div data-type="page" id="page_2">
                <div data-type="document-title" id="auto_1234_1"><em data-effect="italics">Italics</em> & not italics with <sub>subscript</sub> and <sup>superscript</sup> text</div>
              </div>
            </div>
            <div data-type="chapter">
              <div data-type="page" id="page_3">
                <div data-type="document-title" id="auto_1234_2"><em data-effect="italics">Italics</em> & not italics with <sub>subscript</sub> and <sup>superscript</sup> text</div>
              </div>
              <div data-type="page" id="page_4">
                <div data-type="document-title" id="auto_1234_3"><em data-effect="italics">Italics</em> & not italics with <sub>subscript</sub> and <sup>superscript</sup> text</div>
              </div>
            </div>
          </div>
          <div data-type="unit">
            <div data-type="chapter">
              <div data-type="page" id="page_5">
                <div data-type="document-title" id="auto_1234_4"><em data-effect="italics">Italics</em> & not italics with <sub>subscript</sub> and <sup>superscript</sup> text</div>
              </div>
              <div data-type="page" id="page_6">
                <div data-type="document-title" id="auto_1234_5"><em data-effect="italics">Italics</em> & not italics with <sub>subscript</sub> and <sup>superscript</sup> text</div>
              </div>
            </div>
            <div data-type="chapter">
              <div data-type="page" id="page_7">
                <div data-type="document-title" id="auto_1234_6"><em data-effect="italics">Italics</em> & not italics with <sub>subscript</sub> and <sup>superscript</sup> text</div>
              </div>
              <div data-type="page" id="page_8">
                <div data-type="document-title" id="auto_1234_7"><em data-effect="italics">Italics</em> & not italics with <sub>subscript</sub> and <sup>superscript</sup> text</div>
              </div>
            </div>
          </div>
        HTML
    ).units
  end

  it 'works' do
    described_class.v1(chapter: chapter)
    expect(chapter).to match_snapshot_auto
  end

  context 'when module title has span children elements' do
    it 'keeps title within its children' do
      described_class.v1(chapter: chapter3)
      expect(chapter3).to match_snapshot_auto
    end
  end

  context 'when book has added target lables for modules' do
    it 'stores module link text' do
      pantry = chapter2.pantry(name: :link_text)
      expect(pantry).to receive(:store).with('1.1 Review of Functions', { label: 'page_123' })
      described_class.v1(chapter: chapter2)
    end
  end

  context 'when module pages has added custom target labels' do
    it 'stores link text' do
      pantry = chapter2.pantry(name: :link_text)
      expect(pantry).to receive(:store).with('<span class="label-counter">1.1</span><span class="title-label-text"> Review of Functions</span>', { label: 'page_123' })
      described_class.v1(chapter: chapter2, options: { custom_target_label: true })
    end
  end

  context 'when book has blocked adding target lables for modules' do
    it 'does not store module link text' do
      pantry = chapter2.pantry(name: :link_text)
      expect(pantry).not_to receive(:store).with('1.1 Review of Functions', { label: 'page_123' })
      described_class.v1(chapter: chapter2, options: { block_target_label: true })
    end
  end

  context 'when book has added target labels and uses grammatical cases' do
    it 'stores link text' do
      with_locale(:pl) do
        stub_locales({
          'module': {
            'nominative': 'Podrozdział',
            'genitive': 'Podrozdziału'
          }
        })

        pantry = chapter2.pantry(name: :nominative_link_text)
        expect(pantry).to receive(:store).with('Podrozdział 1.1 Review of Functions', { label: 'page_123' })

        pantry = chapter2.pantry(name: :genitive_link_text)
        expect(pantry).to receive(:store).with('Podrozdziału 1.1 Review of Functions', { label: 'page_123' })
        described_class.v1(chapter: chapter2, options: { cases: true })
      end
    end
  end

  context 'when unit numbering is enabled' do
    it 'includes unit count, chapter count in unit, and page count in chapter' do
      units.chapters.each do |chapter|
        described_class.v1(chapter: chapter, options: { unit_numbering: true })
      end
      expect(units.to_a.join).to match_snapshot_auto
    end
  end
end
