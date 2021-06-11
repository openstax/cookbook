# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BookAnswerKeyContainer::V1 do
  let(:book) do
    book_containing(html:
      <<~HTML
        #{metadata_element}
          <div data-type="chapter">
            <div data-type="page">
              This is a page
            </div>
          </div>
      HTML
    )
  end

  it 'works' do
    expect(described_class.new.bake(book: book)).to match_normalized_html(
      <<~HTML
        <div class="os-eob os-solutions-container" data-type="composite-chapter" data-uuid-key=".solutions">
          <h1 data-type="document-title">
            <span class="os-text">Answer Key</span>
          </h1>
          <div data-type="metadata" style="display: none;">
            <h1 data-type="document-title" itemprop="name">Answer Key</h1>
            <div class="authors" id="authors_copy_1">Authors</div>
            <div class="publishers" id="publishers_copy_1">Publishers</div>
            <div class="print-style" id="print-style_copy_1">Print Style</div>
            <div class="permissions" id="permissions_copy_1">Permissions</div>
            <div data-type="subject" id="subject_copy_1">Subject</div>
          </div>
        </div>
      HTML
    )
  end

  it 'generates container with solution (singular) class' do
    expect(described_class.new.bake(book: book, solutions_plural: false)).to match_normalized_html(
      <<~HTML
        <div class="os-eob os-solution-container" data-type="composite-chapter" data-uuid-key=".solution">
          <h1 data-type="document-title">
            <span class="os-text">Answer Key</span>
          </h1>
          <div data-type="metadata" style="display: none;">
            <h1 data-type="document-title" itemprop="name">Answer Key</h1>
            <div class="authors" id="authors_copy_1">Authors</div>
            <div class="publishers" id="publishers_copy_1">Publishers</div>
            <div class="print-style" id="print-style_copy_1">Print Style</div>
            <div class="permissions" id="permissions_copy_1">Permissions</div>
            <div data-type="subject" id="subject_copy_1">Subject</div>
          </div>
        </div>
      HTML
    )
  end
end
