# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeIframes do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeIframes::V1).to receive(:bake).with(book: 'book')
    described_class.v1(book: 'book')
  end
end
