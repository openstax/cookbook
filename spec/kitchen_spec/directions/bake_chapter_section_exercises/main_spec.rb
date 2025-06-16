# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterSectionExercises do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeChapterSectionExercises::V1).to receive(:bake)
      .with(
        chapter: 'chapter1',
        options: {
          trash_title: false,
          create_title: true,
          numbering_options: { mode: :chapter_page, separator: '.' }
        })
    described_class.v1(chapter: 'chapter1', options: {})
  end
end
