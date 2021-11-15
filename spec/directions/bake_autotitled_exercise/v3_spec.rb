# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeAutotitledExercise do
  let(:exercise) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-element-type="check-understanding" data-type="exercise" id="some-id">
            <div data-type="title">Check Your Understanding</div>
            <div data-type="problem">
              <p>problem 1</p>
            </div>
            <div data-type="solution">
              <p>solution</p>
            </div>
          </div>
        HTML
      )
    ).chapters.exercises.first
  end

  let(:exercise_no_solution) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-element-type="grasp-check" data-type="exercise">
            <div data-type="problem">
              <p>problem 1</p>
            </div>
          </div>
        HTML
      )
    ).chapters.exercises.first
  end

  it 'bakes' do
    described_class.v3(exercise: exercise, title: 'Check Your Understanding')

    expect(exercise).to match_normalized_html(
      <<~HTML
        <div class="unnumbered os-hasSolution" data-element-type="check-understanding" data-type="exercise" id="some-id">
          <h3 class="os-title" data-type="title">
            <span class="os-title-label">Check Your Understanding</span>
          </h3>
          <div data-type="problem">
            <div class="os-problem-container">
              <p>problem 1</p>
            </div>
          </div>
          <div data-type="solution" id="some-id-solution">
            <h4 class="solution-title" data-type="title">
              <span class="os-text">Solution</span>
            </h4>
            <div class="os-solution-container">
              <p>solution</p>
            </div>
          </div>
        </div>
      HTML
    )
  end

  it 'works if no solution' do
    described_class.v3(exercise: exercise_no_solution, title: 'abc')
    expect(exercise_no_solution).to match_normalized_html(
      <<~HTML
        <div class="unnumbered" data-element-type="grasp-check" data-type="exercise">
          <h3 class="os-title" data-type="title">
            <span class="os-title-label">abc</span>
          </h3>
          <div data-type="problem">
            <div class="os-problem-container">
              <p>problem 1</p>
            </div>
          </div>
        </div>
      HTML
    )
  end
end
