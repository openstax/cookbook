# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeAnnotationClasses do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeAnnotationClasses::V1).to receive(:bake)
      .with(book: 'book1')
    described_class.v1(book: 'book1')
  end
end
