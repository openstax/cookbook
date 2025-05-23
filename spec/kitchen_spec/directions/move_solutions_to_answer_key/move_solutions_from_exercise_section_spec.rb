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

  let(:book_containing_section_with_exercises) do
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

  context 'when in appendix it adds dynamic title for exercises/solution sections in appendices' do
    before do
      stub_locales({
        'appendix_sections': {
          'exercise-section': 'Exercise Section'
        }
      })
    end

    it 'bakes' do
      described_class.v1(within: book_containing_section_with_exercises, append_to: append_element, section_class: 'exercise-section', options: { in_appendix: true })
      expect(append_element).to match_snapshot_auto
    end
  end

  it 'bakes' do
    described_class.v1(within: book_containing_section_with_exercises, append_to: append_element, section_class: 'exercise-section')
    expect(append_element).to match_snapshot_auto
  end

  it 'bakes a numbered section' do
    described_class.v1(within: book_containing_section_with_exercises, append_to: append_element, section_class: 'another-exercise-section', title_number: '3.4')
    expect(append_element).to match_snapshot_auto
  end

  it 'bakes without section title' do
    described_class.v1(within: book_containing_section_with_exercises, append_to: append_element, section_class: 'exercise-section', options: { add_title: false })
    expect(append_element).to match_snapshot_auto
  end

  it 'bakes when within is a section' do
    described_class.v1(within: book_containing_section_with_exercises.sections.first, append_to: append_element, section_class: 'exercise-section', options: { add_title: false })
    expect(append_element).to match_snapshot_auto
  end
end
