# frozen_string_literal: true

RSpec.describe Kitchen::Directions::MoveSolutionsFromNumberedNote do
  before do
    stub_locales({
      'notes': {
        'some-note': 'Some Note',
        'your-turn': 'Your Turn'
      }
    })
  end

  let(:chapter_with_numbered_notes) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="note" class="some-note">
            <div data-type="exercise">
              <div data-type="solution">Solution 1</div>
            </div>
          </div>
          <div data-type="note" class="some-note">
            <div class="os-note-body">
              <div data-type="injected-exercise">
                <div data-type="exercise-question">
                  <div data-type="question-solution">
                    <span class="os-number">1.</div>
                    <div class="os-solution-container">injected solution</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div data-type="note" class="some-note">
            <div class="os-note-body">
              <div data-type="exercise">
                <div data-type="solution">
                  <span class="os-number">1.1</div>
                  <div class="os-solution-container">Solution 1</div>
                </div>
              </div>
            </div>
          </div>
        HTML
      )
    )
  end

  let(:chapter_with_your_turn_notes) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="page">
            <div data-type="note" class="your-turn">
                <div data-type="exercise-question">
                  <div data-type="question-stem">
                    Consider the set of possible outcomes when you flip a coin,
                    <p></p>
                  </div>
                  <div data-type="question-solution">
                    <span data-math="some math"></span>
                  </div>
                </div>
              </div>
            </div>
            <div data-type="note" class="some-note">
              <div data-type="exercise">
                <div data-type="solution">Solution 1</div>
              </div>
            </div>
            <div data-type="note" class="some-note">
              <div class="os-note-body">
                <div data-type="injected-exercise">
                  <div data-type="exercise-question">
                    <div data-type="question-solution">
                      <span class="os-number">1.</div>
                      <div class="os-solution-container">injected solution</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      HTML
    )
  end

  let(:append_element) do
    new_element(
      <<~HTML
        <div class="top-level"></div>
      HTML
    )
  end

  it 'works' do
    described_class.v1(chapter: chapter_with_numbered_notes, append_to: append_element, note_class: 'some-note')
    expect(append_element).to match_snapshot_auto
  end

  it 'works with your turn notes' do
    described_class.v2(chapter: chapter_with_your_turn_notes.chapters.first,
                       append_to: append_element, note_class: 'your-turn')

    expect(append_element).to match_snapshot_auto
  end
end
