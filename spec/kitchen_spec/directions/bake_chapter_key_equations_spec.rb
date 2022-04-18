# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterKeyEquations do

  before do
    stub_locales({
      'eoc_key_equations': 'Key Equations',
      'eoc_composite_metadata_title': 'Chapter Review',
      'eoc': {
        'key-equations': 'Key Equations'
      }
    })
  end

  let(:chapter) do
    chapter_element(
      page_element(
        <<~HTML
          <section class="key-equations">
            <h3 data-type="title">WWF History</h3>
            <p>Equations blah.</p>
          </section>
        HTML
      )
    )
  end

  let(:append_to) do
    new_element(
      <<~HTML
        <div class="os-eoc os-chapter-review-container" data-type="composite-chapter" data-uuid-key=".chapter-review">
          <h2 data-type="document-title" id="composite-chapter-1">
            <span class="os-text">foo</span>
          </h2>
          <div data-type="metadata" style="display: none;">
            <h1 data-type="document-title" itemprop="name">foo</h1>
            <div>metadata</div>
          </div>
        </div>
      HTML
    )
  end

  context 'when append_to is nil' do
    it 'works' do
      described_class.v1(chapter: chapter, metadata_source: metadata_element)
      expect(
        chapter
      ).to match_snapshot_auto
    end
  end

  context 'when append_to is not nil' do
    it 'works' do
      described_class.v1(chapter: chapter, metadata_source: metadata_element, append_to: append_to)
      expect(
        append_to
      ).to match_snapshot_auto
    end
  end
end
