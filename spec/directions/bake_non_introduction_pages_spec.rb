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

  context 'when pages has added target labels' do
    it 'stores link text' do
      pantry = chapter2.pantry(name: :link_text)
      expect(pantry).to receive(:store).with('1.1', { label: 'page_123' })
      described_class.v1(chapter: chapter2, add_target_label: true)
    end
  end
end
