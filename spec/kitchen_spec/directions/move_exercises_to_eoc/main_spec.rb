# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::MoveExercisesToEOC do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::MoveExercisesToEOC::V1).to receive(:bake)
      .with(chapter: 'chapter1', metadata_source: 'metadata', append_to: 'element', klass: 'class', uuid_prefix: 'uuid')
    described_class.v1(chapter: 'chapter1', metadata_source: 'metadata', append_to: 'element', klass: 'class', uuid_prefix: 'uuid')
  end

  it 'calls v2' do
    expect_any_instance_of(Kitchen::Directions::MoveExercisesToEOC::V2).to receive(:bake)
      .with(chapter: 'chapter1', metadata_source: 'metadata', append_to: 'element', klass: 'class', uuid_prefix: 'uuid')
    described_class.v2(chapter: 'chapter1', metadata_source: 'metadata', append_to: 'element', klass: 'class', uuid_prefix: 'uuid')
  end

  it 'calls v3' do
    expect_any_instance_of(Kitchen::Directions::MoveExercisesToEOC::V3).to receive(:bake)
      .with(chapter: 'chapter1', metadata_source: 'metadata', append_to: 'element', klass: 'class', uuid_prefix: 'uuid')
    described_class.v3(chapter: 'chapter1', metadata_source: 'metadata', append_to: 'element', klass: 'class', uuid_prefix: 'uuid')
  end
end
