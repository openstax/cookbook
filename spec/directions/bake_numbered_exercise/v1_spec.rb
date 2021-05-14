# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeNumberedExercise::V1 do
  let(:exercise1) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="exercise" id="exercise_id">
            <div data-type="problem" id="problem_id">
              <p>example content</p>
            </div>
            <div data-type="solution" id="solution_id">
              <p>Solution content</p>
            </div>
          </div>
        HTML
      )
    ).chapters.exercises.first
  end

  context 'when solutions are not suppressed' do
    it 'works' do
      described_class.new.bake(exercise: exercise1, number: '1.1')

      expect(exercise1).to match_normalized_html(
        <<~HTML
          <div data-type="exercise" id="exercise_id" class="os-hasSolution">
            <div data-type="problem" id="problem_id">
              <a class="os-number" href="#exercise_id-solution">1.1</a>
              <span class="os-divider">. </span>
              <div class="os-problem-container">
                <p>example content</p>
              </div>
            </div>
            <div data-type="solution" id="exercise_id-solution"><a class="os-number" href="#exercise_id">1.1</a>
              <span class="os-divider">. </span>
              <div class="os-solution-container">
                <p>Solution content</p>
              </div>
            </div>
          </div>
        HTML
      )
    end
  end

  context 'when solutions are suppressed' do
    it 'works' do
      described_class.new.bake(exercise: exercise1, number: '1.1', suppress_solution: true)

      expect(exercise1).to match_normalized_html(
        <<~HTML
          <div data-type="exercise" id="exercise_id">
            <div data-type="problem" id="problem_id">
              <span class='os-number'>1.1</span>
              <span class="os-divider">. </span>
              <div class="os-problem-container">
                <p>example content</p>
              </div>
            </div>
          </div>
        HTML
      )
    end
  end
end
