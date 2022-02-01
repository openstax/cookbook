# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeNumberedNotes do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeNumberedNotes::V1).to receive(:bake)
      .with(book: 'book1', classes: 'class1', cases: false)
    described_class.v1(book: 'book1', classes: 'class1', cases: false)
  end

  it 'calls v2' do
    expect_any_instance_of(Kitchen::Directions::BakeNumberedNotes::V2).to receive(:bake)
      .with(book: 'book2', classes: 'class2')
    described_class.v2(book: 'book2', classes: 'class2')
  end

  it 'calls v3' do
    expect_any_instance_of(Kitchen::Directions::BakeNumberedNotes::V3).to receive(:bake)
      .with(book: 'book3', classes: 'class3', suppress_solution: true)
    described_class.v3(book: 'book3', classes: 'class3', suppress_solution: true)
  end
end
