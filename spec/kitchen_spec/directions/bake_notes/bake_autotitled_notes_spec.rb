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
            <div>
              <h3 data-type="title">Subsection title</h3>
            </div>
          </div>
          <div data-type="note" id="untitlednote" class="123">
            <p>content</p>
            <div data-type="note" id="untitlednote" class="foo">
              <p>this is a nested note</p>
            </div>
          </div>

          <div data-type="note" class="project" id='parent-note-1'>
            <div data-type="title">Resonance</div>
            <p>Consider an undamped system exhibiting...</p>
            <ol>
              <li>Consider the differential equation</li>
              <li>Graph the solution. What happens to the behavior of the system over time?</li>
              <li>
                In the real world... <span data-type="term" class="no-emphasis">Tacoma Narrows Bridge</span>
                <div data-type="note" class="media-2" id='child-note-1'>
                  <p>blah</p>
                </div>
                <div data-type="note" class="media-2" id='child-note-2'>
                  <p><a href="http://www.openstax.org/l/20_TacomaNarro2">video</a> blah</p>
                </div>
              </li>
              <li>
                Another real-world example of resonance is a singer...
                <div data-type="note" class="media-2" id='child-note-3'>
                  <p>video</p>
                </div>
              </li>
            </ol>
          </div>
        HTML
      )
    )
  end

  let(:numbered_exercise_within_note) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="note" id="untitlednote" class="foo">
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

  let(:unnumbered_exercise_within_note) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="note" id="untitlednote2" class="blah">
            <p>this is a note</p>
            <div class="unnumbered" data-type="exercise" id="3361">
              <div data-type="problem" id="505">
                <ul>
                  <li>What do you need to know to perform this analysis at the very minimum?</li>
                </ul>
              </div>
              <div data-type="solution" id="506">
                <p>Something</p>
              </div>
            </div>
          </div>
        HTML
      )
    )
  end

  before do
    stub_locales({
      'iframe_link_text': 'Click to view content',
      'notes': {
        'foo': 'Bar',
        'baz': 'Baaa',
        'blah': 'Blah',
        'project': 'Project',
        'media-2': 'Media',
        'interactive': 'Link to Learning'
      },
      'exercises': {
        'exercise': 'Exercise',
        'solution': 'Answer'
      }
    })
  end

  it 'bakes' do
    described_class.v1(book: book_with_notes, classes: %w[foo baz project media-2 interactive])
    expect(book_with_notes.body.pages.first).to match_snapshot_auto
  end

  context 'when autotitled notes have numbered exercise within' do
    it 'bakes' do
      described_class.v1(book: numbered_exercise_within_note, classes: %w[foo], bake_exercises: true)
      expect(numbered_exercise_within_note.body.pages.first.notes.to_s).to match_snapshot_auto
    end
  end

  context 'when autotitled notes have unnumbered exercise within' do
    it 'bakes' do
      described_class.v1(book: unnumbered_exercise_within_note, classes: %w[blah], bake_exercises: true)
      expect(unnumbered_exercise_within_note.body.pages.first.notes.to_s).to match_snapshot_auto
    end
  end

  context 'when book does not use grammatical cases' do
    it 'stores link text' do
      pantry = book_with_notes.pantry(name: :link_text)
      expect(pantry).to receive(:store).with('Resonance', { label: 'parent-note-1' })
      expect(pantry).to receive(:store).with('note <em data-effect="italics">title</em>', { label: 'noteId' })
      described_class.v1(book: book_with_notes, classes: %w[foo baz project media-2 interactive])
    end
  end

  context 'when book uses grammatical cases' do
    it 'stores link text' do
      with_locale(:pl) do
        stub_locales({
          'note': {
            'nominative': 'Ramka',
            'genitive': 'Ramki'
          }
        })

        pantry = book_with_notes.pantry(name: :nominative_link_text)
        expect(pantry).to receive(:store).with('Ramka Resonance', { label: 'parent-note-1' })
        expect(pantry).to receive(:store).with('Ramka note <em data-effect="italics">title</em>', { label: 'noteId' })

        pantry = book_with_notes.pantry(name: :genitive_link_text)
        expect(pantry).to receive(:store).with('Ramki Resonance', { label: 'parent-note-1' })
        expect(pantry).to receive(:store).with('Ramki note <em data-effect="italics">title</em>', { label: 'noteId' })
        described_class.v1(book: book_with_notes, classes: %w[foo baz project media-2 interactive], cases: true)
      end
    end
  end
end
