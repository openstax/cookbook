# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeAllNumberedExerciseTypes do
  let(:compound_ex_section) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <section>
            <div data-type="injected-exercise" data-injected-from-nickname="multiFR" data-injected-from-version="2" data-injected-from-url="url" data-tags="type:practice all" data-is-vocab="False">
              <div data-type="exercise-stimulus">Exercise stimulus</div>
              <div data-type="exercise-question" id="id1" data-is-answer-order-important="False" data-formats="free-response" data-id="1">
                <div data-type="question-stem">Question 1</div>
                <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed">
                  solution 1
                </div>
              </div>
              <div data-type="exercise-question" id="id2" data-is-answer-order-important="False" data-formats="free-response" data-id="2">
                <div data-type="question-stem">Question 2</div>
                <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed">
                  solution 2
                </div>
              </div>
              <div data-type="exercise-question" id="id3" data-is-answer-order-important="False" data-formats="free-response" data-id="3">
                <div data-type="question-stem">Question 3</div>
                <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed">
                  solution 3
                </div>
              </div>
            </div>
            <div data-type="exercise" id="exercise_id">
              <div data-type="problem" id="problem_id">
                <p>example content</p>
              </div>
              <div data-type="solution" id="solution_id">
                <p>Solution content</p>
              </div>
            </div>
          </section>
        HTML
      )
    ).chapters.sections.first
  end

  it 'works' do
    described_class.v1(within: compound_ex_section)
    expect(compound_ex_section).to match_normalized_html(
      <<~HTML
        <section>
          <div data-type="injected-exercise" data-injected-from-nickname="multiFR" data-injected-from-version="2" data-injected-from-url="url" data-tags="type:practice all" data-is-vocab="False">
            <div data-type="exercise-stimulus">Exercise stimulus</div>
            <div class="os-hasSolution" data-type="exercise-question" id="id1" data-is-answer-order-important="False" data-formats="free-response" data-id="1">
              <a class="os-number" href="#id1-solution">1</a>
              <span class="os-divider">. </span>
              <div class="os-problem-container">
                <div data-type="question-stem">Question 1</div>
              </div>
              <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed" id="id1-solution">
                <a class="os-number" href="#id1">1</a>
                <span class="os-divider">. </span>
                <div class="os-solution-container">
                solution 1
              </div>
              </div>
            </div>
            <div class="os-hasSolution" data-formats="free-response" data-id="2" data-is-answer-order-important="False" data-type="exercise-question" id="id2">
              <a class="os-number" href="#id2-solution">2</a>
              <span class="os-divider">. </span>
              <div class="os-problem-container">
                <div data-type="question-stem">Question 2</div>
              </div>
              <div data-solution-source="collaborator" data-solution-type="detailed" data-type="question-solution" id="id2-solution">
                <a class="os-number" href="#id2">2</a>
                <span class="os-divider">. </span>
                <div class="os-solution-container">
                solution 2
              </div>
              </div>
            </div>
            <div class="os-hasSolution" data-formats="free-response" data-id="3" data-is-answer-order-important="False" data-type="exercise-question" id="id3">
              <a class="os-number" href="#id3-solution">3</a>
              <span class="os-divider">. </span>
              <div class="os-problem-container">
                <div data-type="question-stem">Question 3</div>
              </div>
              <div data-solution-source="collaborator" data-solution-type="detailed" data-type="question-solution" id="id3-solution">
                <a class="os-number" href="#id3">3</a>
                <span class="os-divider">. </span>
                <div class="os-solution-container">
                solution 3
              </div>
              </div>
            </div>
          </div>
          <div class="os-hasSolution" data-type="exercise" id="exercise_id">
            <div data-type="problem" id="problem_id">
              <a class="os-number" href="#exercise_id-solution">4</a>
              <span class="os-divider">. </span>
              <div class="os-problem-container">
                <p>example content</p>
              </div>
            </div>
            <div data-type="solution" id="exercise_id-solution">
              <a class="os-number" href="#exercise_id">4</a>
              <span class="os-divider">. </span>
              <div class="os-solution-container">
                <p>Solution content</p>
              </div>
            </div>
          </div>
        </section>
      HTML
    )
  end
end
