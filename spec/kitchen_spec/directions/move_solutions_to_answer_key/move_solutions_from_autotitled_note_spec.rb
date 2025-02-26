# frozen_string_literal: true

RSpec.describe Kitchen::Directions::MoveSolutionsFromAutotitledNote do
  before do
    stub_locales({
      'notes': {
        'some-note': 'Some Note'
      }
    })
  end

  let(:chapter_with_numbered_notes) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter"><h2 data-type="document-title">Chapter 1</h2>
          <div data-type="page"><h3 data-type="document-title">Welcome to Page 1</h3>
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

  it 'v1 works' do
    described_class.v1(page: chapter_with_numbered_notes, append_to: append_element, note_class: 'some-note')
    expect(append_element).to match_snapshot_auto
  end

  context 'when there is a title' do
    let(:title) do
      new_element(
        <<~HTML
          <div>Some title</div>
        HTML
      )
    end

    it 'works' do
      described_class.v1(page: chapter_with_numbered_notes, append_to: append_element, note_class: 'some-note', title: title)
      expect(append_element).to match_snapshot_auto
    end
  end

  it 'v2 works' do
    chapter_with_numbered_notes.chapters.first.prepend(child: "<div data-type='document-title'>Chapter 1</div>")
    described_class.v2(chapter: chapter_with_numbered_notes.chapters.first, append_to: append_element, note_class: 'some-note')
    expect(append_element).to match_snapshot_auto
  end
end
