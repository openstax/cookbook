# frozen_string_literal: true

RSpec.describe Kitchen::Directions::MoveSolutionsFromExerciseSection do
  # rubocop:disable Style/FormatStringToken
  # Token formatting within locales is different from template formatting & shouldn't be linted.
  before do
    stub_locales({
      'eoc': {
        'exercise-section': 'Exercise Section',
        'another-exercise-section': 'Another Exercise %{number} Section'
      }
    })
  end
  # rubocop:enable Style/FormatStringToken

  let(:section_with_exercises) do
    book_containing(html:
      <<~HTML
        <section class="exercise-section">
          <div data-type="exercise">
            <div data-type="solution">
              <div class="os-solution-container">Solution 1</div>
            </div>
          </div>
          <div data-type="exercise">
            <div data-type="solution">Solution 2</div>
          </div>
          <div data-type="exercise">
            No solution here
          </div>
          <div data-type="injected-exercise">
            <div data-type="exercise-question">
              <div data-type="question-solution">
                <div class="os-solution-container">injected solution</div>
              </div>
            </div>
          </div>
        </section>
        <section class="another-exercise-section">
          <div data-type="exercise">
            <div data-type="solution">
              <div class="os-solution-container">Solution 1</div>
            </div>
          </div>
        </section>
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

  it 'bakes' do
    described_class.v1(chapter: section_with_exercises, append_to: append_element, section_class: 'exercise-section')
    expect(append_element).to match_normalized_html(
      <<~HTML
        <div class="top-level">
          <div class="os-solution-area">
            <h3 data-type="title">
              <span class="os-title-label">Exercise Section</span>
            </h3>
            <div data-type="solution">
              <div class="os-solution-container">Solution 1</div>
            </div>
            <div data-type="solution">Solution 2</div>
            <div data-type="question-solution">
              <div class="os-solution-container">injected solution</div>
            </div>
          </div>
        </div>
      HTML
    )
  end

  it 'bakes a numbered section' do
    described_class.v1(chapter: section_with_exercises, append_to: append_element, section_class: 'another-exercise-section', title_number: '3.4')
    expect(append_element).to match_normalized_html(
      <<~HTML
        <div class="top-level">
          <div class="os-solution-area">
            <h3 data-type="title">
              <span class="os-title-label">Another Exercise 3.4 Section</span>
            </h3>
            <div data-type="solution">
              <div class="os-solution-container">Solution 1</div>
            </div>
          </div>
        </div>
      HTML
    )
  end
end
