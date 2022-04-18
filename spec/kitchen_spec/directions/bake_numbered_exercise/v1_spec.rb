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

  let(:appendix_exercise) do
    book_containing(html:
      <<~HTML
        <div class="appendix" data-type="page" id="page_1">
          <section>
            <div data-type="exercise" id="exercise_id">
              <div data-type="problem" id="problem_id">
                <p>example content</p>
              </div>
              <div data-type="solution" id="solution_id">
                <p>Solution content</p>
              </div>
            </div>
          </section>
        </div>
      HTML
    ).pages('$.appendix').first.search('section').exercises.first
  end

  context 'when solutions are not suppressed' do
    it 'works' do
      described_class.v1(exercise: exercise1, number: '1.1')

      expect(exercise1).to match_snapshot_auto
    end
  end

  context 'when solutions are suppressed' do
    it 'works' do
      described_class.v1(exercise: exercise1, number: '1.1', suppress_solution_if: true)

      expect(exercise1).to match_snapshot_auto
    end
  end

  context 'when even solutions are suppressed' do
    context 'when number is odd' do
      it 'works' do
        described_class.v1(exercise: exercise1, number: 1, suppress_solution_if: :even?, note_suppressed_solutions: true)
        expect(exercise1).to match_snapshot_auto
      end
    end

    context 'when number is even' do
      it 'works' do
        described_class.v1(exercise: exercise1, number: 2, suppress_solution_if: :even?, note_suppressed_solutions: true)
        expect(exercise1).to match_snapshot_auto
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
        expect(exercise1).to match_snapshot_auto
      end
    end
  end

  context 'when the solution is in an appendix' do
    it 'works' do
      described_class.v1(exercise: appendix_exercise, number: 'A1')

      expect(appendix_exercise).to match_snapshot_auto
    end
  end

end
