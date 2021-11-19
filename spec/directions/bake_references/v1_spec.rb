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

  it 'works' do
    described_class.v1(book: book1, metadata_source: metadata_element, numbered_title: false)

    expect(book1.body).to match_normalized_html(
      <<~HTML
        <body>
          <div data-type="chapter">
            <h1 data-type="document-title" id="chapTitle1">
              <span class="os-part-text">Chapter </span>
              <span class="os-number">1</span>
              <span class="os-divider"> </span>
              <span class="os-text" data-type="" itemprop="">Title Text Chapter 1</span>
            </h1>
            <div data-type="page">
              <div data-type="metadata" style="display: none;">
                <span data-type="revised" id="revised">Revised</span>
                <span data-type="slug" id="slug">Slug</span>
                <div class="authors" id="authors">Authors</div>
                <div class="publishers" id="publishers">Publishers</div>
                <div class="print-style" id="print-style">Print Style</div>
                <div class="permissions" id="permissions">Permissions</div>
                <div data-type="subject" id="subject">Subject</div>
              </div>
              <p>
                <a data-type="cite" href="#auto_12345">
                  <sup class="os-citation-number">1</sup>
                </a>
                <span class="os-reference-link-separator">, </span>
                <a data-type="cite" href="#auto_54321">
                  <sup class="os-citation-number">2</sup>
                </a>
              " However, in the 2018 midterm elections, an estimated 31 percent of Americans under thirty turned out to vote, the highest level of young adult engagement in decades."
              <a data-type="cite" href="#auto_54322">
                <sup class="os-citation-number">3</sup>
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
              <div data-type="metadata" style="display: none;">
                <span data-type="revised" id="revised">Revised</span>
                <span data-type="slug" id="slug">Slug</span>
                <div class="authors" id="authors">Authors</div>
                <div class="publishers" id="publishers">Publishers</div>
                <div class="print-style" id="print-style">Print Style</div>
                <div class="permissions" id="permissions">Permissions</div>
                <div data-type="subject" id="subject">Subject</div>
              </div>
              <p>
                <a data-type="cite" href="#auto_6789">
                  <sup class="os-citation-number">1</sup>
                </a>
              </p>
            </div>
          </div>
          <div class="os-eob os-reference-container" data-type="composite-page" data-uuid-key=".reference">
            <h1 data-type="document-title">
              <span class="os-text">References</span>
            </h1>
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
            <div class="os-chapter-area">
              <h2 data-type="document-title">
                <span class="os-text" data-type="" itemprop="">Title Text Chapter 1</span>
              </h2>
              <div class="reference" data-type="note" display="inline" id="auto_12345"><span class="os-reference-number">1. </span>
                  Reference 1
                </div>
              <div class="reference" data-type="note" display="inline" id="auto_54321"><span class="os-reference-number">2. </span>
                  Reference 2
                </div>
              <div class="reference" data-type="note" display="inline" id="auto_54322"><span class="os-reference-number">3. </span>
                  Reference 3
                </div>
            </div>
            <div class="os-chapter-area">
              <h2 data-type="document-title">
                <span class="os-text" data-type="" itemprop="">Title Text Chapter 2</span>
              </h2>
              <div class="reference" data-type="note" display="inline" id="auto_6789"><span class="os-reference-number">1. </span>
                  Reference 4
                </div>
            </div>
          </div>
        </body>
      HTML
    )
  end

  it 'add chapter number to references title' do
    described_class.v1(book: book1, metadata_source: metadata_element, numbered_title: true)
    expect(
      book1.body.search('div.os-reference-container').search('div.os-chapter-area > [data-type="document-title"]')
    ).to match_normalized_html(
      <<~HTML
        <h2 data-type="document-title">
          <span class="os-number">1</span>
          <span class="os-divider"> </span>
          <span class="os-text" data-type="" itemprop="">Title Text Chapter 1</span>
        </h2>
        <h2 data-type="document-title">
          <span class="os-number">2</span>
          <span class="os-divider"> </span>
          <span class="os-text" data-type="" itemprop="">Title Text Chapter 2</span>
        </h2>
      HTML
    )
  end
end
