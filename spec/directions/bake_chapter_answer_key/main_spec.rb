# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterAnswerKey do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeChapterAnswerKey::V1).to receive(:bake)
      .with(chapter: 'chapter1', metadata_source: 'metadata', strategy: 'strategy', append_to: 'element')
    described_class.v1(chapter: 'chapter1', metadata_source: 'metadata', strategy: 'strategy', append_to: 'element')
  end
end
