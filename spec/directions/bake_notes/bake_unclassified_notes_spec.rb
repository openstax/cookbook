# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeUnclassifiedNotes do
  let(:book_with_notes) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="note" id="titlednote">
            <div data-type="title" id="titleId">note <em data-effect="italics">title</em></div>
            <p>content</p>
          </div>
          <div data-type="note" id="untitlednote">
            <p>content</p>
          </div>
          <div data-type="note" id="untitlednote" class="foo">
            <p>content</p>
          </div>
        HTML
      )
    )
  end

  before do
    stub_locales({
      'notes': {
        'foo': 'Bar'
      }
    })
  end

  it 'bakes' do
    described_class.v1(book: book_with_notes)
    expect(book_with_notes.body.pages.first).to match_normalized_html(
      <<~HTML
        <div data-type="page">
          <div data-type="note" id="titlednote">
            <h3 class="os-title" data-type="title">
              <span class="os-title-label" data-type="" id="titleId">note <em data-effect="italics">title</em></span>
            </h3>
            <div class="os-note-body">
              <p>content</p>
            </div>
          </div>
          <div data-type="note" id="untitlednote">
            <div class="os-note-body">
              <p>content</p>
            </div>
          </div>
          <div data-type="note" id="untitlednote" class="foo">
            <p>content</p>
          </div>
        </div>
      HTML
    )
  end
end
