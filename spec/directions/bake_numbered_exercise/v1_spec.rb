# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeNumberedExercise do
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

    context 'when there is a stimulus' do
      let(:multipart_exercise) do
        book_containing(html:
          one_chapter_with_one_page_containing(
            <<~HTML
              <div data-type="exercise" id="ex1">
                <div data-type="problem" id="prob1">
                  <div class="question-stimulus">Stimulus</div>
                  <div class="question-stem">question 1</div>
                  <div class="question-stem">question 2</div>
                  <div class="question-stem">question 3</div>
                </div>
              </div>
            HTML
          )
        ).chapters.exercises.first
      end

      let(:multipart_exercise_with_one_part) do
        book_containing(html:
          one_chapter_with_one_page_containing(
            <<~HTML
              <div data-type="exercise" id="ex1">
                <div data-type="problem" id="prob1">
                  <div class="question-stimulus">Stimulus</div>
                  <div class="question-stem">question 1</div>
                </div>
              </div>
            HTML
          )
        ).chapters.exercises.first
      end

      it 'bakes a multipart exercise' do
        described_class.v1(exercise: multipart_exercise, number: 2)
        expect(multipart_exercise).to match_normalized_html(
          <<~HTML
            <div data-type="exercise" id="ex1">
              <div data-type="problem" id="prob1">
                <span class="os-number">2</span>
                <span class="os-divider">. </span>
                <div class="os-problem-container">
                  <div class="question-stimulus">Stimulus</div>
                  <ol type="a">
                    <li><div class="question-stem">question 1</div></li>
                    <li><div class="question-stem">question 2</div></li>
                    <li><div class="question-stem">question 3</div></li>
                  </ol>
                </div>
              </div>
            </div>
          HTML
        )
      end

      it 'doesn\'t add a list when there is just one part' do
        described_class.v1(exercise: multipart_exercise_with_one_part, number: 2)
        expect(multipart_exercise_with_one_part).to match_normalized_html(
          <<~HTML
            <div data-type="exercise" id="ex1">
              <div data-type="problem" id="prob1">
                <span class="os-number">2</span>
                <span class="os-divider">. </span>
                <div class="os-problem-container">
                  <div class="question-stimulus">Stimulus</div>
                  <div class="question-stem">question 1</div>
                </div>
              </div>
            </div>
          HTML
        )
      end
    end

  end
end
