# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeNumberedNotes do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeNumberedNotes::V1).to receive(:bake)
      .with(book: 'book1', classes: 'class1')
    described_class.v1(book: 'book1', classes: 'class1')
  end

  it 'calls v2' do
    expect_any_instance_of(Kitchen::Directions::BakeNumberedNotes::V2).to receive(:bake)
      .with(book: 'book2', classes: 'class2')
    described_class.v2(book: 'book2', classes: 'class2')
  end
end
