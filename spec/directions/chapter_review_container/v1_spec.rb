# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::ChapterReviewContainer::V1 do
  before do
    stub_locales({
      'eoc': {
        'exercises': 'Exercises',
        'chapter-review': 'Chapter Review'
      }
    })
  end

  let(:chapter) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="page">
            This is a page
          </div>
        </div>
      HTML
    ).chapters.first
  end

  it 'works' do
    described_class.new.bake(chapter: chapter, metadata_source: metadata_element)
    described_class.new.bake(chapter: chapter, metadata_source: metadata_element, klass: 'exercises')
    expect(chapter).to match_normalized_html(
      <<~HTML
        <div data-type="chapter">
          <div data-type="page">
            This is a page
          </div>
          <div class="os-eoc os-chapter-review-container" data-type="composite-chapter" data-uuid-key=".chapter-review">
            <h2 data-type="document-title">
              <span class="os-text">Chapter Review</span>
            </h2>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Chapter Review</h1>
              <div class="authors" id="authors_copy_1">Authors</div>
              <div class="publishers" id="publishers_copy_1">Publishers</div>
              <div class="print-style" id="print-style_copy_1">Print Style</div>
              <div class="permissions" id="permissions_copy_1">Permissions</div>
              <div data-type="subject" id="subject_copy_1">Subject</div>
            </div>
          </div>
          <div class="os-eoc os-exercises-container" data-type="composite-chapter" data-uuid-key=".exercises">
            <h2 data-type="document-title">
              <span class="os-text">Exercises</span>
            </h2>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Exercises</h1>
              <div class="authors" id="authors_copy_1">Authors</div>
              <div class="publishers" id="publishers_copy_1">Publishers</div>
              <div class="print-style" id="print-style_copy_1">Print Style</div>
              <div class="permissions" id="permissions_copy_1">Permissions</div>
              <div data-type="subject" id="subject_copy_1">Subject</div>
            </div>
          </div>
        </div>
      HTML
    )
  end
end
