# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::BookElement do

  let(:book) do
    book_containing(html:
      <<~HTML
        <nav id="toc">
          <h1 class="os-toc-title">Contents</h1>
        </nav>
        <div>This is a div</div>
        #{metadata_element}
      HTML
    )
  end

  it 'returns the body' do
    expect(book.body).to match_normalized_html(
      <<~HTML
        <body>
          <nav id="toc">
            <h1 class="os-toc-title">Contents</h1>
          </nav>
          <div>This is a div</div>
          <div data-type="metadata" style="display: none;">
            <div class="authors" id="authors">Authors</div>
            <div class="publishers" id="publishers">Publishers</div>
            <div class="print-style" id="print-style">Print Style</div>
            <div class="permissions" id="permissions">Permissions</div>
            <div data-type="subject" id="subject">Subject</div>
          </div>
        </body>
      HTML
    )
  end

  it 'returns the metadata' do
    expect(book.metadata).to match_normalized_html(
      <<~HTML
        <div data-type="metadata" style="display: none;">
          <div class="authors" id="authors">Authors</div>
          <div class="publishers" id="publishers">Publishers</div>
          <div class="print-style" id="print-style">Print Style</div>
          <div class="permissions" id="permissions">Permissions</div>
          <div data-type="subject" id="subject">Subject</div>
        </div>
      HTML
    )
  end

  it 'returns the toc' do
    expect(book.toc).to match_normalized_html(
      <<~HTML
        <nav id="toc">
          <h1 class="os-toc-title">Contents</h1>
        </nav>
      HTML
    )
  end
end
