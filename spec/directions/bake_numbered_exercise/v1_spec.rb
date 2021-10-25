# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeNumberedExercise do

  before do
    stub_locales({
      'exercise': 'Exercise',
      'solution': 'Solution'
    })
  end

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
      described_class.v1(exercise: exercise1, number: '1.1')

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
      described_class.v1(exercise: exercise1, number: '1.1', suppress_solution_if: true)

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

  context 'when even solutions are suppressed' do
    context 'when number is odd' do
      it 'works' do
        described_class.v1(exercise: exercise1, number: 1, suppress_solution_if: :even?, note_suppressed_solutions: true)
        expect(exercise1).to match_normalized_html(
          <<~HTML
            <div data-type="exercise" id="exercise_id" class="os-hasSolution">
              <div data-type="problem" id="problem_id">
                <a class="os-number" href="#exercise_id-solution">1</a>
                <span class="os-divider">. </span>
                <div class="os-problem-container">
                  <p>example content</p>
                </div>
              </div>
              <div data-type="solution" id="exercise_id-solution"><a class="os-number" href="#exercise_id">1</a>
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

    context 'when number is even' do
      it 'works' do
        described_class.v1(exercise: exercise1, number: 2, suppress_solution_if: :even?, note_suppressed_solutions: true)
        expect(exercise1).to match_normalized_html(
          <<~HTML
            <div data-type="exercise" id="exercise_id" class="os-hasSolution-trashed">
              <div data-type="problem" id="problem_id">
                <span class="os-number">2</span>
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

    context 'when book does not use grammatical cases' do
      it 'stores link text' do
        pantry = exercise1.pantry(name: :link_text)
        expect(pantry).to receive(:store).with('Exercise 1.1', { label: 'exercise_id' })
        described_class.v1(exercise: exercise1, number: '1')
      end
    end

    context 'when book uses grammatical cases' do
      it 'stores link text' do
        with_locale(:pl) do
          stub_locales({
            'exercise': {
              'nominative': 'Ćwiczenie',
              'genitive': 'Ćwiczenia'
            }
          })

          pantry = exercise1.pantry(name: :nominative_link_text)
          expect(pantry).to receive(:store).with('Ćwiczenie 1.1', { label: 'exercise_id' })

          pantry = exercise1.pantry(name: :genitive_link_text)
          expect(pantry).to receive(:store).with('Ćwiczenia 1.1', { label: 'exercise_id' })
          described_class.v1(exercise: exercise1, number: '1', cases: true)
        end
      end
    end

    context 'when exercises remain grouped with solutions' do
      it 'works' do
        described_class.v1(exercise: exercise1, number: '4', solution_stays_put: true)
        expect(exercise1).to match_normalized_html(
          <<~HTML
            <div data-type="exercise" id="exercise_id">
              <div data-type="problem" id="problem_id">
                <span class="os-number">4</span>
                <span class="os-divider">. </span>
                <div class="os-problem-container">
                  <p>example content</p>
                </div>
              </div>
              <div data-type="solution" id="solution_id">
                <h4 class="solution-title" data-type="title">
                  <span class="os-text">Solution</span>
                </h4>
                <div class="os-solution-container">
                  <p>Solution content</p>
                </div>
              </div>
            </div>
          HTML
        )
      end
    end

  end
end
