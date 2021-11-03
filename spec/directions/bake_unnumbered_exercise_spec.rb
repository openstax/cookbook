# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeUnnumberedExercise do

  let(:book_with_unnumbered_exercise) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="exercise" class="unnumbered">
            <div data-type="problem">problem</div>
            <div data-type="solution">solution 1</div>
            <div data-type="solution">solution 2</div>
          </div>
        HTML
      )
    )
  end

  it 'works' do
    described_class.v1(exercise: book_with_unnumbered_exercise.exercises.first)
    expect(book_with_unnumbered_exercise.pages.first).to match_normalized_html(
      <<~HTML
        <div data-type="page">
          <div class="unnumbered" data-type="exercise">
            <div data-type="problem">
              <div class="os-problem-container">problem</div>
            </div>
            <div data-type="solution">
              <div class="os-solution-container">solution 1</div>
            </div>
            <div data-type="solution">
              <div class="os-solution-container">solution 2</div>
            </div>
          </div>
        </div>
      HTML
    )
  end

end
