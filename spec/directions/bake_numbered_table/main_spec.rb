# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeNumberedTable do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeNumberedTable::V1).to receive(:bake).with(table: 'blah', number: '7', always_caption: false)
    described_class.v1(table: 'blah', number: '7', always_caption: false)
  end

  it 'calls v2' do
    expect_any_instance_of(Kitchen::Directions::BakeNumberedTable::V2).to receive(:bake).with(table: 'blah', number: '7')
    described_class.v2(table: 'blah', number: '7')
  end
end
