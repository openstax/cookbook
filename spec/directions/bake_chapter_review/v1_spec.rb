# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterReview::V1 do
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
              <div class="authors" id="authors">Authors</div><div class="publishers" id="publishers">Publishers</div><div class="print-style" id="print-style">Print Style</div><div class="permissions" id="permissions">Permissions</div><div data-type="subject" id="subject">Subject</div>
            </div>
          </div>
        </div>
      HTML
    )
  end
end
