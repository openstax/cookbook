# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeFreeResponse do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeFreeResponse::V1).to receive(:bake)
      .with(chapter: 'chapter1', metadata_source: 'metadata', append_to: 'append')
    described_class.v1(chapter: 'chapter1', metadata_source: 'metadata', append_to: 'append')
  end
end
