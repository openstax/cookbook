# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeNumberedTable do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeNumberedTable::V1).to receive(:bake).with(table: 'blah', number: '7', cases: false, move_caption_on_top: false, label_class: nil)
    described_class.v1(table: 'blah', number: '7', cases: false, move_caption_on_top: false, label_class: nil)
  end

  it 'calls v2' do
    expect_any_instance_of(Kitchen::Directions::BakeNumberedTable::V2).to receive(:bake).with(table: 'blah', number: '7', cases: false, label_class: nil)
    described_class.v2(table: 'blah', number: '7', cases: false, label_class: nil)
  end
end
