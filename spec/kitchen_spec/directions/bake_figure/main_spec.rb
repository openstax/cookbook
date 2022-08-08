# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeFigure do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeFigure::V1).to receive(:bake)
      .with(figure: 'figure1', number: '7', cases: false)
    described_class.v1(figure: 'figure1', number: '7', cases: false)
  end
end
