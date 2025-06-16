# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeReferences do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeReferences::V1).to receive(:bake)
      .with(book: 'book1', metadata_source: 'metadata_element', numbered_title: false)
    described_class.v1(book: 'book1', metadata_source: 'metadata_element')
  end

  it 'calls v2' do
    expect_any_instance_of(Kitchen::Directions::BakeReferences::V2).to receive(:bake)
      .with(book: 'book1', metadata_source: 'metadata_element')
    described_class.v2(book: 'book1', metadata_source: 'metadata_element')
  end

  it 'calls v3' do
    expect_any_instance_of(Kitchen::Directions::BakeReferences::V3).to receive(:bake)
      .with(book: 'book1', metadata_source: 'metadata_element')
    described_class.v3(book: 'book1', metadata_source: 'metadata_element')
  end

  it 'calls v4' do
    expect_any_instance_of(Kitchen::Directions::BakeReferences::V4).to receive(:bake)
      .with(
        book: 'book1',
        chapters: %w[1 2 3],
        metadata_source: 'metadata_element',
        cases: false,
        numbering_options: { mode: :chapter_page, separator: '.' })
    described_class.v4(book: 'book1', chapters: %w[1 2 3], metadata_source: 'metadata_element', cases: false)
  end
end
