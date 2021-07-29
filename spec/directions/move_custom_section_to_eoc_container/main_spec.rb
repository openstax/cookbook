# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::MoveCustomSectionToEocContainer do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::MoveCustomSectionToEocContainer::V1).to receive(:bake)
      .with(chapter: 'chapter1', metadata_source: 'metadata', container_key: 'some-class', uuid_key: 'other-class', section_selector: 'another-class',
            append_to: 'element', include_intro_page: true, wrap_section: false, wrap_content: false)
    described_class.v1(chapter: 'chapter1', metadata_source: 'metadata', container_key: 'some-class', uuid_key: 'other-class',
                       section_selector: 'another-class', append_to: 'element')
  end
end
