# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeExercisePrefixes do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeExercisePrefixes::V1).to receive(:bake).with(chapter: 'chapter1', sections_prefixed: 'some-sections')
    described_class.v1(chapter: 'chapter1', sections_prefixed: 'some-sections')
  end
end
