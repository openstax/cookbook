# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeCustomSections do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeCustomSections::V1).to receive(:bake).with(chapter: 'chapter1', custom_sections_properties: 'some-properties')
    described_class.v1(chapter: 'chapter1', custom_sections_properties: 'some-properties')
  end
end
