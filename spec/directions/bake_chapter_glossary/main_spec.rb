# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterGlossary do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeChapterGlossary::V1).to receive(:bake)
      .with(chapter: 'chapter1', metadata_source: 'metadata', append_to: 'append', uuid_prefix: 'uuid', has_para: false)
    described_class.v1(chapter: 'chapter1', metadata_source: 'metadata', append_to: 'append', uuid_prefix: 'uuid', has_para: false)
  end
end
