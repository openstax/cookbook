# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::EocSectionTitleLinkSnippet do

  let(:book1) do
    book_containing(html:
    <<~HTML
      <div data-type="chapter">
        <h1 data-type="document-title" id="chapTitle1">
          <span class="os-part-text">Chapter </span>
          <span class="os-number">1</span>
          <span class="os-divider"> </span>
          <span class="os-text" data-type="" itemprop="">Title Text Chapter 1</span>
        </h1>
        <div data-type="page">
          #{metadata_element}
          <div data-type="document-title" id="someId1">1.1 Page</div>
          <p>
            <a href="#auto_12345" data-type="cite">
              <div data-type="note" class="reference" display="inline" id="auto_12345">
                Reference 1
              </div>
            </a>
          </p>
        </div>
      </div>
    HTML
    )
  end

  it 'works for links' do
    expect(described_class.v1(page: book1.chapters.first.pages.first)).to match_normalized_html(
      <<~HTML
        <a href="#someId1">
          <h3 data-type="document-title" id="someId1_copy_1">
            <span class="os-number">1.1</span>
            <span class="os-divider"> </span>
            <span class="os-text" data-type="" itemprop="">1.1 Page</span>
          </h3>
        </a>
      HTML
    )
  end

  it 'works for div wrapper' do
    expect(
      described_class.v1(page: book1.chapters.first.pages.first, wrapper: 'div')
    ).to match_normalized_html(
      <<~HTML
        <div>
          <h3 data-type="document-title" id="someId1_copy_1">
            <span class="os-number">1.1</span>
            <span class="os-divider"> </span>
            <span class="os-text" data-type="" itemprop="">1.1 Page</span>
          </h3>
        </div>
      HTML
    )
  end

  it 'works when the wrapper is not needed' do
    expect(
      described_class.v1(page: book1.chapters.first.pages.first, title_tag: 'h2', wrapper: nil)
    ).to match_normalized_html(
      <<~HTML
        <h2 data-type="document-title" id="someId1_copy_1">
          <span class="os-number">1.1</span>
          <span class="os-divider"> </span>
          <span class="os-text" data-type="" itemprop="">1.1 Page</span>
        </h2>
      HTML
    )
  end
end
