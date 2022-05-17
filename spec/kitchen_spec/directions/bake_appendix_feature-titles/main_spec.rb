require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeAppendixFeatureTitles do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeAppendixFeatureTitles::V1).to receive(:bake)
      .with(section: 'section1', selector: 'section_selector')
    described_class.v1(section: 'section1', selector: 'section_selector')
  end
end
