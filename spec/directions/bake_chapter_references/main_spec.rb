# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterReferences do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeChapterReferences::V1).to receive(:bake)
      .with(chapter: 'chapter1', metadata_source: 'metadata', uuid_prefix: 'uuid', klass: 'klass')
    described_class.v1(chapter: 'chapter1', metadata_source: 'metadata', uuid_prefix: 'uuid', klass: 'klass')
  end

  it 'calls v2' do
    expect_any_instance_of(Kitchen::Directions::BakeChapterReferences::V2).to receive(:bake)
      .with(chapter: 'chapter1', metadata_source: 'metadata', uuid_prefix: 'uuid', klass: 'klass')
    described_class.v2(chapter: 'chapter1', metadata_source: 'metadata', uuid_prefix: 'uuid', klass: 'klass')
  end
end
