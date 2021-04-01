# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeNumberedExercise do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeNumberedExercise::V1).to receive(:bake)
      .with(exercise: 'exercise1', number: '1.1')
    described_class.v1(exercise: 'exercise1', number: '1.1')
  end
end
