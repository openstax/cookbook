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
    expect(compound_ex_section).to match_snapshot_auto
  end
end
