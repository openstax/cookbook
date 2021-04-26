# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterKeyConcepts do
  let(:chapter) do
    chapter_element(
      <<~HTML
        <div data-type="page">
          <h1 data-type="document-title" id="page1TitleId">Page 1</h1>
          <section id="sectionId1" class="key-concepts">
            <h3 data-type="document-title">WWF History</h3>
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
            <h3 data-type="document-title">WWF History</h3>
            <p>Concepts two</p>
          </section>
        </div>
      HTML
    )
  end

  it 'works' do
    expect(
      described_class.v1(chapter: chapter, metadata_source: metadata_element)
    ).to match_normalized_html(
      <<~HTML
        <div data-type="chapter">
          <div data-type="page">
            <h1 data-type="document-title" id="page1TitleId">Page 1</h1>
          </div>
          <div data-type="page">
            <h2 data-type="document-title" id="page2TitleId">
              <span class="os-number">1.1</span>
              <span class="os-divider"> </span>
              <span data-type="" itemprop="" class="os-text">Baked Title</span>
            </h2>
          </div>
          <div class="os-eoc os-key-concepts-container" data-type="composite-page" data-uuid-key=".key-concepts">
            <h2 data-type="document-title">
              <span class="os-text">Key Concepts</span>
            </h2>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Key Concepts</h1>
              <div class="authors" id="authors_copy_1">Authors</div><div class="publishers" id="publishers_copy_1">Publishers</div><div class="print-style" id="print-style_copy_1">Print Style</div><div class="permissions" id="permissions_copy_1">Permissions</div><div data-type="subject" id="subject_copy_1">Subject</div>
            </div>
            <div class="os-key-concepts">
              <div class="os-section-area">
                <section id="sectionId1" class="key-concepts">
                  <a href="#page1TitleId">
                    <h3 data-type="document-title" id="page1TitleId_copy_1">
                      <span class="os-number">1.1</span>
                      <span class="os-divider"> </span>
                      <span class="os-text" data-type="" itemprop="">Page 1</span>
                    </h3>
                  </a>
                  <p>Concepts blah.</p>
                </section>
              </div>
              <div class="os-section-area">
                <section id="sectionId2" class="key-concepts">
                  <a href="#page2TitleId">
                    <h3 data-type="document-title" id="page2TitleId_copy_1">
                      <span class="os-number">1.2</span>
                      <span class="os-divider"> </span>
                      <span class="os-text" data-type="" itemprop="">Baked Title</span>
                    </h3>
                  </a>
                  <p>Concepts two</p>
                </section>
              </div>
            </div>
          </div>
        </div>
      HTML
    )
  end
end
