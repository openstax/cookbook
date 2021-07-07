# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::EocCompositePageContainer do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::EocCompositePageContainer::V1).to receive(:bake)
      .with(container_key: 'some-section', uuid_key: 'some-section', metadata_source: 'metadata', content: 'content', append_to: 'append')
    described_class.v1(container_key: 'some-section', uuid_key: 'some-section', metadata_source: 'metadata', content: 'content', append_to: 'append')
  end
end
