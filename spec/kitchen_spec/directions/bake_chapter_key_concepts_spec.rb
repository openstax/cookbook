# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterKeyConcepts do
  before do
    stub_locales({
      'eoc_composite_metadata_title': 'Chapter Review',
      'eoc': {
        'key-concepts': 'Key Concepts'
      }
    })
  end

  let(:chapter) do
    chapter_element(
      <<~HTML
        <div data-type="page" id="testidOne">
          <h1 data-type="document-title" id="page1TitleId">Page 1</h1>
          <section id="sectionId1" class="key-concepts">
            <h3 data-type="title">WWF History</h3>
            <p>Concepts blah.</p>
          </section>
        </div>
        <div data-type="page">
          <h2 data-type="document-title" id="page2TitleId">
            <span class="os-number">1.1</span>
            <span class="os-divider"> </span>
            <span data-type="" itemprop="" class="os-text">Baked Title</span>
          </h2>
          <section id="sectionId2" class="key-concepts">
            <h3 data-type="title">WWF History</h3>
            <p>Concepts two</p>
          </section>
        </div>
      HTML
    )
  end

  let(:chapter_with_modules_titles_children) do
    chapter_element(
      <<~HTML
        <div data-type="page" id="testidOne">
          <h1 data-type="document-title" id="page1TitleId"><em data-effect="italics">Italics</em> & not italics with <sub>subscript</sub> and <sup>superscript</sup> text</h1>
          <section id="sectionId1" class="key-concepts">
            <h3 data-type="title">WWF History</h3>
            <p>Concepts blah.</p>
          </section>
        </div>
        <div data-type="page">
          <h2 data-type="document-title" id="page2TitleId">
            <span class="os-number">1.1</span>
            <span class="os-divider"> </span>
            <span data-type="" itemprop="" class="os-text"><em data-effect="italics">Italics</em> & not italics with <sub>subscript</sub> and <sup>superscript</sup> text</span>
          </h2>
          <section id="sectionId2" class="key-concepts">
            <h3 data-type="title">WWF History</h3>
            <p>Concepts two</p>
          </section>
        </div>
      HTML
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
      expect(
        described_class.v1(chapter: chapter, metadata_source: metadata_element)
      ).to match_snapshot_auto
    end
  end

  context 'when append_to is not nil' do
    it 'works' do
      expect(
        described_class.v1(chapter: chapter, metadata_source: metadata_element, append_to: append_to)
      ).to match_snapshot_auto
    end
  end

  context 'when there are children elemnts in modules titles' do
    it 'keeps module title children elements' do
      expect(
        described_class.v1(chapter: chapter_with_modules_titles_children, metadata_source: metadata_element)
      ).to match_snapshot_auto
    end
  end
end
