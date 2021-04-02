# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeAutotitledNotes do
  let(:book_with_notes) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="note" id="noteId" class="foo">
            <p>content</p>
          </div>
          <div data-type="note" id="noteId" class="baz">
            <div data-type="title" id="titleId">note <em data-effect="italics">title</em></div>
            <p>content</p>
          </div>
          <div data-type="note" id="untitlednote" class="123">
            <p>content</p>
          </div>
        HTML
      )
    )
  end

  before do
    stub_locales({
      'notes': {
        'foo': 'Bar',
        'baz': 'Baaa'
      }
    })
  end

  it 'bakes' do
    described_class.v1(book: book_with_notes, classes: %w[foo baz])
    expect(book_with_notes.body.pages.first).to match_normalized_html(
      <<~HTML
        <div data-type="page">
          <div class="foo" data-type="note" id="noteId">
            <h3 class="os-title" data-type="title">
              <span class="os-title-label">Bar</span>
            </h3>
            <div class="os-note-body">
              <p>content</p>
            </div>
          </div>
          <div class="baz" data-type="note" id="noteId">
            <h3 class="os-title" data-type="title">
              <span class="os-title-label">Baaa</span>
            </h3>
            <div class="os-note-body">
              <h4 class="os-subtitle" data-type="title" id="titleId">
                <span class="os-subtitle-label">note <em data-effect="italics">title</em></span>
              </h4>
              <p>content</p>
            </div>
          </div>
          <div data-type="note" id="untitlednote" class="123">
            <p>content</p>
          </div>
        </div>
      HTML
    )
  end
end
