# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeIndex do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeIndex::V1).to receive(:bake).with(book: 'blah')
    described_class.v1(book: 'blah')
  end
end
