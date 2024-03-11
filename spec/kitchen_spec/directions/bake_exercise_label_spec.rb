# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeExerciseWithTitle do

  let(:example_with_exercise) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="example">
            <h2 class="os-title">
              <span class="os-title-label">Example </span>
              <span class="os-number">1.1</span>
              <span class="os-divider"> </span>
            </h2>
            <div class="body">
              <div data-type="exercise" class="unnumbered">
                <div data-type="problem">
                  <h3 data-type="problem-title">
                    <span class="os-title-label">Problem</span>
                  </h3>
                  <div class="os-problem-container">
                    <p>Determine what the key terms refer to in the following study.</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        HTML
      )
    )
  end

  it 'bakes' do
    described_class.v1(within: example_with_exercise)
    expect(example_with_exercise.search('[data-type="exercise"]').first).to match_snapshot_auto
  end
end
