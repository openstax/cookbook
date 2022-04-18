# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeReferences do

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
          <p>
            <a href="#auto_12345" data-type="cite">
              <div data-type="note" class="reference" display="inline" id="auto_12345">
                Reference 1
              </div>
            </a>
            <a href="#auto_54321" data-type="cite">
              <div data-type="note" class="reference" display="inline" id="auto_54321">
                Reference 2
              </div>
            </a>
            " However, in the 2018 midterm elections, an estimated 31 percent of Americans under thirty turned out to vote, the highest level of young adult engagement in decades."
            <a href="#auto_54322" data-type="cite">
              <div data-type="note" class="reference" display="inline" id="auto_54322">
                Reference 3
              </div>
            </a>
          </p>
        </div>
      </div>
      <div data-type="chapter">
        <h1 data-type="document-title" id="chapTitle2">
          <span class="os-part-text">Chapter </span>
          <span class="os-number">2</span>
          <span class="os-divider"> </span>
          <span class="os-text" data-type="" itemprop="">Title Text Chapter 2</span>
        </h1>
        <div data-type="page">
          #{metadata_element}
          <p>
            <a href="#auto_6789" data-type="cite">
              <div data-type="note" class="reference" display="inline" id="auto_6789">
                Reference 4
              </div>
            </a>
          </p>
        </div>
      </div>
    HTML
    )
  end

  it 'v1 works' do
    described_class.v1(book: book1, metadata_source: metadata_element, numbered_title: false)

    expect(book1.body).to match_snapshot_auto
  end

  it 'add chapter number to references title' do
    described_class.v1(book: book1, metadata_source: metadata_element, numbered_title: true)
    expect(
      book1.body.search('div.os-reference-container').search('div.os-chapter-area > [data-type="document-title"]').to_s
    ).to match_snapshot_auto
  end
end
