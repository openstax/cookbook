# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::MoveCustomSectionToEocContainer do
  before do
    stub_locales({
      'eoc': {
        'top-level': 'Top Level Container',
        'some-eoc-section': 'Some Eoc Section'
      }
    })
  end

  let(:append_to) do
    new_element(
      <<~HTML
        <div class="os-eoc os-top-level-container" data-type="composite-chapter" data-uuid-key=".top-level">
          <h2 data-type="document-title" id="composite-chapter-1">
            <span class="os-text">#{I18n.t(:'eoc.top-level')}</span>
          </h2>
          <div data-type="metadata" style="display: none;">
            <h1 data-type="document-title" itemprop="name">#{I18n.t(:'eoc.top-level')}</h1>
            <div>metadata</div>
          </div>
        </div>
      HTML
    )
  end

  let(:book_with_section_to_move) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="page" class="introduction">
            <h2 data-type="document-title" id="first" itemprop="name">First Title</h2>
            <section id="sectionId1" class="some-eoc-section">
              <p>content</p>
            </section>
            <section id="sectionId2" class="some-eoc-section">
              <p>content</p>
            </section>
          </div>
          <div data-type="page">
            <section id="sectionId3" class="some-eoc-section">
              <p>content</p>
            </section>
          </div>
        </div>
      HTML
    )
  end

  let(:book_without_section) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="page">
            <h2 data-type="document-title" id="first" itemprop="name">First Title</h2>
            <section id="sectionId1" class="some-other-eoc-section">
              <p>content</p>
            </section>
          </div>
        </div>
      HTML
    )
  end

  context 'when append_to is not nil' do
    it 'works with intro pages' do
      described_class.v1(
        chapter: book_with_section_to_move.chapters.first,
        metadata_source: metadata_element,
        container_key: 'some-eoc-section',
        uuid_key: '.some-eoc-section',
        section_selector: 'section.some-eoc-section',
        append_to: append_to
      )
      expect(append_to).to match_normalized_html(
        <<~HTML
          <div class="os-eoc os-top-level-container" data-type="composite-chapter" data-uuid-key=".top-level">
            <h2 data-type="document-title" id="composite-chapter-1">
              <span class="os-text">Top Level Container</span>
            </h2>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Top Level Container</h1>
              <div>metadata</div>
            </div>
            <div class="os-eoc os-some-eoc-section-container" data-type="composite-page" data-uuid-key=".some-eoc-section">
              <h3 data-type="title">
                <span class="os-text">Some Eoc Section</span>
              </h3>
              <div data-type="metadata" style="display: none;">
                <h1 data-type="document-title" itemprop="name">Some Eoc Section</h1>
                <div class="authors" id="authors_copy_1">Authors</div>
                <div class="publishers" id="publishers_copy_1">Publishers</div>
                <div class="print-style" id="print-style_copy_1">Print Style</div>
                <div class="permissions" id="permissions_copy_1">Permissions</div>
                <div data-type="subject" id="subject_copy_1">Subject</div>
              </div>
              <section class="some-eoc-section" id="sectionId1">
                <p>content</p>
              </section>
              <section class="some-eoc-section" id="sectionId2">
                <p>content</p>
              </section>
              <section class="some-eoc-section" id="sectionId3">
                <p>content</p>
              </section>
            </div>
          </div>
        HTML
      )
    end

    it 'adds a section-level wrapper' do
      described_class.v1(
        chapter: book_with_section_to_move.chapters.first,
        metadata_source: metadata_element,
        container_key: 'some-eoc-section',
        uuid_key: '.some-eoc-section',
        section_selector: 'section.some-eoc-section',
        append_to: append_to,
        wrap_section: true
      )
      expect(append_to.first('$.os-some-eoc-section-container')).to match_normalized_html(
        <<~HTML
          <div class="os-eoc os-some-eoc-section-container" data-type="composite-page" data-uuid-key=".some-eoc-section">
            <h3 data-type="title">
              <span class="os-text">Some Eoc Section</span>
            </h3>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Some Eoc Section</h1>
              <div class="authors" id="authors_copy_1">Authors</div>
              <div class="publishers" id="publishers_copy_1">Publishers</div>
              <div class="print-style" id="print-style_copy_1">Print Style</div>
              <div class="permissions" id="permissions_copy_1">Permissions</div>
              <div data-type="subject" id="subject_copy_1">Subject</div>
            </div>
            <div class="os-section-area">
              <section class="some-eoc-section" id="sectionId1">
                <p>content</p>
              </section>
            </div>
            <div class="os-section-area">
              <section class="some-eoc-section" id="sectionId2">
                <p>content</p>
              </section>
            </div>
            <div class="os-section-area">
              <section class="some-eoc-section" id="sectionId3">
                <p>content</p>
              </section>
            </div>
          </div>
        HTML
      )
    end

    it 'adds a content-level wrapper' do
      described_class.v1(
        chapter: book_with_section_to_move.chapters.first,
        metadata_source: metadata_element,
        container_key: 'some-eoc-section',
        uuid_key: '.some-eoc-section',
        section_selector: 'section.some-eoc-section',
        append_to: append_to,
        wrap_section: true,
        wrap_content: true
      )
      expect(append_to.first('$.os-some-eoc-section-container')).to match_normalized_html(
        <<~HTML
          <div class="os-eoc os-some-eoc-section-container" data-type="composite-page" data-uuid-key=".some-eoc-section">
            <h3 data-type="title">
              <span class="os-text">Some Eoc Section</span>
            </h3>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Some Eoc Section</h1>
              <div class="authors" id="authors_copy_1">Authors</div>
              <div class="publishers" id="publishers_copy_1">Publishers</div>
              <div class="print-style" id="print-style_copy_1">Print Style</div>
              <div class="permissions" id="permissions_copy_1">Permissions</div>
              <div data-type="subject" id="subject_copy_1">Subject</div>
            </div>
            <div class="os-some-eoc-section">
              <div class="os-section-area">
                <section class="some-eoc-section" id="sectionId1">
                  <p>content</p>
                </section>
              </div>
              <div class="os-section-area">
                <section class="some-eoc-section" id="sectionId2">
                  <p>content</p>
                </section>
              </div>
              <div class="os-section-area">
                <section class="some-eoc-section" id="sectionId3">
                  <p>content</p>
                </section>
              </div>
            </div>
          </div>
        HTML
      )
    end
  end

  context 'when append_to is nil' do
    it 'works' do
      described_class.v1(
        chapter: book_with_section_to_move.chapters.first,
        metadata_source: metadata_element,
        container_key: 'some-eoc-section',
        uuid_key: '.some-eoc-section',
        section_selector: 'section.some-eoc-section'
      )
      expect(book_with_section_to_move.chapters.search('.os-eoc').first).to match_normalized_html(
        <<~HTML
          <div class="os-eoc os-some-eoc-section-container" data-type="composite-page" data-uuid-key=".some-eoc-section">
            <h2 data-type="document-title">
              <span class="os-text">Some Eoc Section</span>
            </h2>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Some Eoc Section</h1>
              <div class="authors" id="authors_copy_1">Authors</div>
              <div class="publishers" id="publishers_copy_1">Publishers</div>
              <div class="print-style" id="print-style_copy_1">Print Style</div>
              <div class="permissions" id="permissions_copy_1">Permissions</div>
              <div data-type="subject" id="subject_copy_1">Subject</div>
            </div>
            <section class="some-eoc-section" id="sectionId1">
              <p>content</p>
            </section>
            <section class="some-eoc-section" id="sectionId2">
              <p>content</p>
            </section>
            <section class="some-eoc-section" id="sectionId3">
              <p>content</p>
            </section>
          </div>
        HTML
      )
    end
  end

  it 'yields the sections' do
    counter = 1
    described_class.v1(chapter: book_with_section_to_move.chapters.first, metadata_source: metadata_element, container_key: 'abc', uuid_key: '.def',
                       section_selector: 'div.jkl') do |section|
      expect(section.id).to eq("sectionId#{counter}")
      counter += 1
    end
  end

  it 'doesn\'t do anything weird when there are no sections' do
    empty_wrapper = new_element('<div></div>')
    described_class.v1(chapter: book_without_section.chapters.first, metadata_source: metadata_element, container_key: 'abc', uuid_key: '.def',
                       section_selector: 'div.jkl', append_to: empty_wrapper)
    expect(empty_wrapper).to match_normalized_html('<div></div>')
  end
end
