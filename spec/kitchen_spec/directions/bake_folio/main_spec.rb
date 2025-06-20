# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeFolio do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeFolio::V1).to receive(:bake).with(
      book: 'book',
      chapters: %w[chapter1],
      options: {
        new_approach: false,
        numbering_options: { mode: :chapter_page, separator: '.' }
      }
    )
    described_class.v1(book: 'book', chapters: %w[chapter1])
  end

  it 'calls v2' do
    expect_any_instance_of(Kitchen::Directions::BakeFolio::V2).to receive(:bake).with(book: 'book', chapters: %w[chapter1])
    described_class.v2(book: 'book', chapters: %w[chapter1])
  end
end
