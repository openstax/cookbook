# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterGlossary::V1 do

  before do
    stub_locales({
      'eoc': {
        'glossary': 'Key Terms'
      }
    })
  end

  let(:chapter) do
    chapter_element(
      <<~HTML
        <div data-type='glossary'>
          <div>
            <dl>
              <dt>ZzZ</dt>
              <dd>Test 1</dd>
            </dl>
            <dl>
              <dt>ZzZ</dt>
              <dd>Achoo</dd>
            </dl>
            <dl>
              <dt>ABD</dt>
              <dd>Test 2</dd>
            </dl>
          </div>
        </div>
      HTML
    )
  end

  let(:chapter_with_pl_diacritics) do
    chapter_element(
      <<~HTML
        <div data-type='glossary'>
          <div>
            <dl>
              <dt>ZzZ</dt>
              <dd>Test 1</dd>
            </dl>
            <dl>
              <dt>ĄBD</dt>
              <dd>Hey</dd>
            </dl>
            <dl>
              <dt>ZzZ</dt>
              <dd>Achoo</dd>
            </dl>
            <dl>
              <dt>ABD</dt>
              <dd>Test 2</dd>
            </dl>
          </div>
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

  let(:chapter_with_para) do
    chapter_element(
      <<~HTML
        <div data-type='glossary'>
          <div>
            <dl>
              <dt>ZzZ</dt>
              <dd>
                <p>Test 1</p>
              </dd>
            </dl>
            <dl>
              <dt>ZzZ</dt>
              <dd>
                <p>Achoo</p>
              </dd>
            </dl>
            <dl>
              <dt>ABD</dt>
              <dd>
                <p>Test 2</p>
              </dd>
            </dl>
          </div>
        </div>
      HTML
    )
  end

  context 'when append_to is nil' do
    it 'works' do
      metadata = metadata_element.append(child:
        <<~HTML
          <div data-type="random" id="subject">Random - should not be included</div>
        HTML
      )
      expect(
        described_class.new.bake(chapter: chapter, metadata_source: metadata)
      ).to match_snapshot_auto
    end
  end

  context 'when append_to is not nil' do
    it 'works' do
      expect(
        described_class.new.bake(chapter: chapter, metadata_source: metadata_element, append_to: append_to)
      ).to match_snapshot_auto
    end
  end

  context 'when terms contain polish diacritics' do
    it 'works' do
      with_locale(:pl) do
        stub_locales({
          'eoc': {
            'glossary': 'Kluczowe pojęcia'
          }
        })
        metadata = metadata_element.append(child:
          <<~HTML
            <div data-type="random" id="subject">Random - should not be included</div>
          HTML
        )
        expect(
          described_class.new.bake(chapter: chapter_with_pl_diacritics, metadata_source: metadata)
        ).to match_snapshot_auto
      end
    end
  end

  context 'when description has para' do
    it 'works' do
      metadata = metadata_element.append(child:
        <<~HTML
          <div data-type="random" id="subject">Random - should not be included</div>
        HTML
      )
      expect(
        described_class.new.bake(chapter: chapter_with_para, metadata_source: metadata, has_para: true)
      ).to match_snapshot_auto
    end
  end

  context 'when no definitions are found' do
    let(:chapter_without_definitions) do
      book_containing(html: one_chapter_with_one_page_containing(
        '<div>this chapter doesn\'t have definitions</div>'
      )).chapters.first
    end

    it 'doesn\'t create an empty wrapper' do
      described_class.new.bake(chapter: chapter_without_definitions, metadata_source: metadata_element)
      expect(chapter_without_definitions).to match_normalized_html(
        <<~HTML
          <div data-type="chapter">
            <div data-type="page" id="testidOne">
              <div>this chapter doesn't have definitions</div>
            </div>
          </div>
        HTML
      )
    end
  end
end
