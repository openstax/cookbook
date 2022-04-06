# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeNonIntroductionPages do

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
    expect(chapter).to match_snapshot_auto
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
      described_class.v1(chapter: chapter2, custom_target_label: true)
    end
  end

  context 'when book has blocked adding target lables for modules' do
    it 'does not store module link text' do
      pantry = chapter2.pantry(name: :link_text)
      expect(pantry).not_to receive(:store).with('1.1 Review of Functions', { label: 'page_123' })
      described_class.v1(chapter: chapter2, block_target_label: true)
    end
  end

end
