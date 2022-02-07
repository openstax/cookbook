# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeCustomTitledNotes do

  let(:book_with_notes) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="note" id="untitlednote" class="foo">
            <p>content</p>
          </div>
          <div data-type="note" id="titlednote" class="bar">
            <div data-type="title" id="titleId">note title</div>
            <p>content</p>
          </div>
        HTML
      )
    )
  end

  it 'bakes' do
    described_class.v1(book: book_with_notes, classes: %w[foo bar])
    expect(book_with_notes.body.pages.first).to match_normalized_html(
      <<~HTML
        <div data-type="page">
          <div data-type="note" id="untitlednote" class="foo">
            <div class="os-note-body">
              <p>content</p>
            </div>
          </div>
          <div data-type="note" id="titlednote" class="bar">
            <h3 class="os-title" data-type="title">
              <span class="os-title-label" id="titleId">note title</span>
            </h3>
            <div class="os-note-body">
              <p>content</p>
            </div>
          </div>
        </div>
      HTML
    )
  end
end
