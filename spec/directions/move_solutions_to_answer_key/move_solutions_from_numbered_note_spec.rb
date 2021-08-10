# frozen_string_literal: true

RSpec.describe Kitchen::Directions::MoveSolutionsFromNumberedNote do
  before do
    stub_locales({
      'notes': {
        'some-note': 'Some Note'
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

  let(:append_element) do
    new_element(
      <<~HTML
        <div class="top-level"></div>
      HTML
    )
  end

  it 'works' do
    described_class.v1(chapter: chapter_with_numbered_notes, append_to: append_element, note_class: 'some-note')
    expect(append_element).to match_normalized_html(
      <<~HTML
        <div class="top-level">
          <div class="os-solution-area">
            <h3 data-type="title">
              <span class="os-title-label">Some Note</span>
            </h3>
            <div data-type="solution">Solution 1</div>
            <div data-type="solution">
              <span class="os-number">1.1</span>
              <div class="os-solution-container">Solution 1</div>
            </div>
          </div>
        </div>
      HTML
    )
  end
end
