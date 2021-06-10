# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BookAnswerKeyContainer do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BookAnswerKeyContainer::V1).to receive(:bake)
      .with(book: 'book', solutions_plural: true)
    described_class.v1(book: 'book')
  end
end
