# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterTitle do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeChapterTitle::V1).to receive(:bake).with(book: 'blah', cases: false)
    described_class.v1(book: 'blah', cases: false)
  end
end
