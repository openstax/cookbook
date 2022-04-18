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

  let(:numbered_exercise_within_note) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="note" id="unclassifiednote">
            <div data-type="title" id="titleId">note title</div>
            <p>this is a note</p>
            <div data-type="exercise" id="3360">
              <div data-type="problem" id="504">
                <ul>
                  <li>What do you need to know to perform this analysis at the very minimum?</li>
                </ul>
              </div>
            </div>
          </div>
        HTML
      )
    )
  end

  before do
    stub_locales({
      'notes': {
        'foo': 'Bar'
      },
      'exercises': {
        'exercise': 'Exercise'
      }
    })
  end

  it 'bakes' do
    described_class.v1(book: book_with_notes)
    expect(book_with_notes.body.pages.first).to match_snapshot_auto
  end

  context 'when unclassified notes have numbered exercise within' do
    it 'bakes' do
      described_class.v1(book: numbered_exercise_within_note, bake_exercises: true)
      expect(numbered_exercise_within_note.body.pages.first.notes.to_s).to match_snapshot_auto
    end
  end
end
