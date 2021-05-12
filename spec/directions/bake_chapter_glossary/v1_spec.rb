# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterGlossary::V1 do

  before do
    stub_locales({
      'eoc_key_terms_title': 'Key Terms',
      'eoc_exercises_title': 'Exercises'
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
      metadata = metadata_element.append(child:
        <<~HTML
          <div data-type="random" id="subject">Random - should not be included</div>
        HTML
      )
      expect(
        described_class.new.bake(chapter: chapter, metadata_source: metadata)
      ).to match_normalized_html(
        <<~HTML
          <div data-type="chapter">
            <div class="os-eoc os-glossary-container" data-type="composite-page" data-uuid-key="glossary">
              <h2 data-type="document-title">
                <span class="os-text">Key Terms</span>
              </h2>
              <div data-type="metadata" style="display: none;">
                <h1 data-type="document-title" itemprop="name">Key Terms</h1>
                <div class="authors" id="authors_copy_1">Authors</div>
                <div class="publishers" id="publishers_copy_1">Publishers</div>
                <div class="print-style" id="print-style_copy_1">Print Style</div>
                <div class="permissions" id="permissions_copy_1">Permissions</div>
                <div data-type="subject" id="subject_copy_1">Subject</div>
              </div>
              <dl>
                <dt>ABD</dt>
                <dd>Test 2</dd>
              </dl>
              <dl>
                <dt>ZzZ</dt>
                <dd>Achoo</dd>
              </dl>
              <dl>
                <dt>ZzZ</dt>
                <dd>Test 1</dd>
              </dl>
            </div>
          </div>
        HTML
      )
    end
  end

  context 'when append_to is not nil' do
    it 'works' do
      expect(
        described_class.new.bake(chapter: chapter, metadata_source: metadata_element, append_to: append_to)
      ).to match_normalized_html(
        <<~HTML
          <div class="os-eoc os-chapter-review-container" data-uuid-key=".chapter-review" data-type="composite-chapter">
            <h2 data-type="document-title" id="composite-chapter-1">
              <span class="os-text">foo</span>
            </h2>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">foo</h1>
              <div>metadata</div>
            </div>
            <div class="os-eoc os-glossary-container" data-type="composite-page" data-uuid-key="glossary">
              <h3 data-type="title">
                <span class="os-text">Key Terms</span>
              </h3>
              <div data-type="metadata" style="display: none;">
                <h1 data-type="document-title" itemprop="name">Exercises</h1>
                <div class="authors" id="authors_copy_1">Authors</div><div class="publishers" id="publishers_copy_1">Publishers</div><div class="print-style" id="print-style_copy_1">Print Style</div><div class="permissions" id="permissions_copy_1">Permissions</div><div data-type="subject" id="subject_copy_1">Subject</div>
              </div>
              <dl>
                <dt>ABD</dt>
                <dd>Test 2</dd>
              </dl>
              <dl>
                <dt>ZzZ</dt>
                <dd>Achoo</dd>
              </dl>
              <dl>
                <dt>ZzZ</dt>
                <dd>Test 1</dd>
              </dl>
            </div>
          </div>
        HTML
      )
    end
  end
end
