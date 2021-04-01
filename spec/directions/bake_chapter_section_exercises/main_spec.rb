# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterSectionExercises do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeChapterSectionExercises::V1).to receive(:bake)
      .with(chapter: 'chapter1')
    described_class.v1(chapter: 'chapter1')
  end
end
