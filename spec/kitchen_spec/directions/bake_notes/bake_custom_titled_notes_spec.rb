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
    expect(book_with_notes.body.pages.first).to match_snapshot_auto
  end
end
