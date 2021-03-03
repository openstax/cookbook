# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Selectors::Base do
  let(:instance) { described_class.new }

  it 'allows overrides' do
    instance.page_summary = 'section.summary'
    instance.override(page_summary: '.section-summary')
    expect(instance.page_summary).to eq '.section-summary'
  end
end
