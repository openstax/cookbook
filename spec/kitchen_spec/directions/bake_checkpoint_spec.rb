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

      expect(checkpoint).to match_snapshot_auto
    end
  end

end
