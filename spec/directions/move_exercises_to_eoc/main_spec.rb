# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::MoveExercisesToEOC do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::MoveExercisesToEOC::V1).to receive(:bake)
      .with(chapter: 'chapter1', metadata_source: 'metadata', append_to: 'element', klass: 'class')
    described_class.v1(chapter: 'chapter1', metadata_source: 'metadata', append_to: 'element', klass: 'class')
  end

  it 'calls v2' do
    expect_any_instance_of(Kitchen::Directions::MoveExercisesToEOC::V2).to receive(:bake)
      .with(chapter: 'chapter1', metadata_source: 'metadata', append_to: 'element', klass: 'class')
    described_class.v2(chapter: 'chapter1', metadata_source: 'metadata', append_to: 'element', klass: 'class')
  end
end
