# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeTheorem do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeTheorem::V1).to receive(:bake)
      .with(theorem: 'exercise1', number: '1.1')
    described_class.v1(theorem: 'exercise1', number: '1.1')
  end
end
