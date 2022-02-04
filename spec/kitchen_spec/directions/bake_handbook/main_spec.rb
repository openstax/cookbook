# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeHandbook do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeHandbook::V1).to receive(:bake).with(book: 'blah', title_element: 'h1')
    described_class.v1(book: 'blah', title_element: 'h1')
  end
end
