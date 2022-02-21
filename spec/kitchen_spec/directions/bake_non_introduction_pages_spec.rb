# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeNonIntroductionPages do

  before do
    stub_locales({
      'module': 'Module'
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

  it 'works' do
    described_class.v1(chapter: chapter)
    expect(chapter).to match_normalized_html(
      <<~HTML
        <div data-type="chapter">
          <div data-type="page" class="chapter-content-module">
            <div data-type="metadata" style="display: none;">\n  \n</div>
            <h2 data-type="document-title" id="anId"><span class="os-number">1.1</span>
              <span class="os-divider"> </span>
              <span data-type="" itemprop="" class="os-text">Review of Functions</span>
            </h2>
          </div>
        </div>
      HTML
    )
  end

  context 'when book does not use grammatical cases' do
    it 'stores link text' do
      pantry = chapter2.pantry(name: :link_text)
      expect(pantry).to receive(:store).with('1.1 Review of Functions', { label: 'page_123' })
      described_class.v1(chapter: chapter2)
    end
  end

  context 'when book uses grammatical cases' do
    it 'stores link text' do
      with_locale(:pl) do
        stub_locales({
          'module': {
            'nominative': 'Moduł',
            'genitive': 'Modułu'
          }
        })

        pantry = chapter2.pantry(name: :nominative_link_text)
        expect(pantry).to receive(:store).with('Moduł 1.1 Review of Functions', { label: 'page_123' })

        pantry = chapter2.pantry(name: :genitive_link_text)
        expect(pantry).to receive(:store).with('Modułu 1.1 Review of Functions', { label: 'page_123' })
        described_class.v1(chapter: chapter2, cases: true)
      end
    end
  end

  context 'when pages has added custom target labels' do
    it 'stores link text' do
      pantry = chapter2.pantry(name: :link_text)
      expect(pantry).to receive(:store).with('<span class="label-counter">1.1</span><span class="title-label-text"> Review of Functions</span>', { label: 'page_123' })
      described_class.v1(chapter: chapter2, custom_target_label: true)
    end
  end

end
