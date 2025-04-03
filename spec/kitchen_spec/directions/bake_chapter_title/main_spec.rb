# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterTitle do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeChapterTitle::V1).to receive(:bake).with(book: 'blah', cases: false)
    described_class.v1(book: 'blah', cases: false)
  end

  it 'calls v2' do
    expect_any_instance_of(Kitchen::Directions::BakeChapterTitle::V2).to receive(:bake).with(chapters: %w[1 2 3], cases: false, numbering_options: {})
    described_class.v2(chapters: %w[1 2 3], cases: false, numbering_options: {})
  end
end
