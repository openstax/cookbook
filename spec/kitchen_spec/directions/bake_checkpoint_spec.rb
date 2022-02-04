# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeCheckpoint do

  let(:checkpoint) do
    note_element(
      <<~HTML
        <div data-type="note" id="note_id" class="checkpoint">
          <div data-type="exercise" id="exercise_id">
            <div data-type="problem" id="problem_id">
              <p> problem content </p>
            </div>
            <div data-type="solution" id="solution_id">
              <p> solution content </p>
            </div>
            <div data-type="commentary" id="commentary_id" data-element-type="hint">
              <div data-type="title" id="commentary_title_id">Hint</div>
              <p> commentary content </p>
            </div>
          </div>
        </div>
      HTML
    )
  end

  describe 'v1' do
    it 'works' do
      described_class.v1(checkpoint: checkpoint, number: '1.2')

      expect(checkpoint).to match_normalized_html(
        <<~HTML
          <div data-type="note" id="note_id" class="checkpoint">
            <div class="os-title">
              <span class="os-title-label">Checkpoint </span>
              <span class="os-number">1.2</span>
              <span class="os-divider"> </span>
            </div>
            <div class="os-note-body">
              <div data-type="exercise" id="exercise_id" class="os-hasSolution unnumbered">
                <div data-type="problem" id="problem_id">
                  <div class="os-problem-container">
                    <p> problem content </p>
                  </div>
                </div>
                <div data-type="solution" id="exercise_id-solution">
                  <span class="os-divider"> </span>
                  <a class="os-number" href="#exercise_id">1.2</a>
                  <div class="os-solution-container">
                    <p> solution content </p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        HTML
      )
    end
  end

end
