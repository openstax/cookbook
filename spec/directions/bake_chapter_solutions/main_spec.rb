# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterSolutions do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeChapterSolutions::V1).to receive(:bake)
      .with(chapter: 'chapter1', metadata_source: 'metadata', uuid_prefix: 'uuid')
    described_class.v1(chapter: 'chapter1', metadata_source: 'metadata', uuid_prefix: 'uuid')
  end
end
