# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeIframes do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeIframes::V1).to receive(:bake).with(outer_element: 'some_outer_element')
    described_class.v1(outer_element: 'some_outer_element')
  end
end
