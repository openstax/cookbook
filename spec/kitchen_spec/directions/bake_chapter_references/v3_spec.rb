# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterReferences::V3 do

  before do
    stub_locales({
      'eoc': {
        'references': 'References'
      }
    })
  end

  let(:chapter) do
    chapter_element(
      <<~HTML
        <section class='reference'>
          <p>
            ZzZ
          </p>
          <p>
            Achoo
          </p>
          <p>
            ABD
          </p>
        </section>
      HTML
    )
  end

  let(:chapter_with_pl_diacritics) do
    chapter_element(
      <<~HTML
        <section class='reference'>
          <p>
            ZzZ
          </p>
          <p>
            ĄBD
          </p>
          <p>
            ABD
          </p>
        </section>
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
            <div class="os-eoc os-references-container" data-type="composite-page" data-uuid-key=".references">
              <h2 data-type="document-title">
                <span class="os-text">References</span>
              </h2>
              <div data-type="metadata" style="display: none;">
                <h1 data-type="document-title" itemprop="name">References</h1>
                <span data-type="revised" id="revised_copy_1">Revised</span>
                <span data-type="slug" id="slug_copy_1">Slug</span>
                <div class="authors" id="authors_copy_1">Authors</div>
                <div class="publishers" id="publishers_copy_1">Publishers</div>
                <div class="print-style" id="print-style_copy_1">Print Style</div>
                <div class="permissions" id="permissions_copy_1">Permissions</div>
                <div data-type="subject" id="subject_copy_1">Subject</div>
              </div>
              <p>
              ABD
            </p>
              <p>
              Achoo
            </p>
              <p>
              ZzZ
            </p>
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
            <div class="os-eoc os-references-container" data-type="composite-page" data-uuid-key=".references">
              <h3 data-type="title">
                <span class="os-text">References</span>
              </h3>
              <div data-type="metadata" style="display: none;">
                <h1 data-type="document-title" itemprop="name">References</h1>
                <span data-type="revised" id="revised_copy_1">Revised</span>
                <span data-type="slug" id="slug_copy_1">Slug</span>
                <div class="authors" id="authors_copy_1">Authors</div>
                <div class="publishers" id="publishers_copy_1">Publishers</div>
                <div class="print-style" id="print-style_copy_1">Print Style</div>
                <div class="permissions" id="permissions_copy_1">Permissions</div>
                <div data-type="subject" id="subject_copy_1">Subject</div>
              </div>
              <p>
              ABD
            </p>
              <p>
              Achoo
            </p>
              <p>
              ZzZ
            </p>
            </div>
          </div>
        HTML
      )
    end
  end

  context 'when terms contain polish diacritics' do
    it 'works' do
      with_locale(:pl) do
        stub_locales({
          'eoc': {
            'references': 'Bibliografia'
          }
        })
        metadata = metadata_element.append(child:
          <<~HTML
            <div data-type="random" id="subject">Random - should not be included</div>
          HTML
        )
        expect(
          described_class.new.bake(chapter: chapter_with_pl_diacritics, metadata_source: metadata)
        ).to match_normalized_html(
          <<~HTML
            <div data-type="chapter">
              <div class="os-eoc os-references-container" data-type="composite-page" data-uuid-key=".references">
                <h2 data-type="document-title">
                  <span class="os-text">Bibliografia</span>
                </h2>
                <div data-type="metadata" style="display: none;">
                  <h1 data-type="document-title" itemprop="name">Bibliografia</h1>
                  <span data-type="revised" id="revised_copy_1">Revised</span>
                  <span data-type="slug" id="slug_copy_1">Slug</span>
                  <div class="authors" id="authors_copy_1">Authors</div>
                  <div class="publishers" id="publishers_copy_1">Publishers</div>
                  <div class="print-style" id="print-style_copy_1">Print Style</div>
                  <div class="permissions" id="permissions_copy_1">Permissions</div>
                  <div data-type="subject" id="subject_copy_1">Subject</div>
                </div>
                <p>
                ABD
              </p>
                <p>
                ĄBD
              </p>
                <p>
                ZzZ
              </p>
              </div>
            </div>
          HTML
        )
      end
    end
  end

  context 'when no references are found' do
    let(:chapter_without_references) do
      book_containing(html: one_chapter_with_one_page_containing(
        '<div>this chapter doesn\'t have references</div>'
      )).chapters.first
    end

    it 'doesn\'t create an empty wrapper' do
      described_class.new.bake(chapter: chapter_without_references, metadata_source: metadata_element)
      expect(chapter_without_references).to match_normalized_html(
        <<~HTML
          <div data-type="chapter">
            <div data-type="page">
              <div>this chapter doesn't have references</div>
            </div>
          </div>
        HTML
      )
    end
  end
end
