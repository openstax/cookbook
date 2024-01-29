# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeSortableSection do

  it 'calls v3' do
    expect_any_instance_of(Kitchen::Directions::BakeSortableSection::V1).to receive(:bake)
      .with(chapter: 'chapter1', metadata_source: 'metadata', klass: 'klass', append_to: 'append', uuid_prefix: 'uuid')
    described_class.v1(chapter: 'chapter1', metadata_source: 'metadata', klass: 'klass', append_to: 'append', uuid_prefix: 'uuid')
  end
end
