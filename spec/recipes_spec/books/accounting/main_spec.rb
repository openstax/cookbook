# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'accounting' do
  it 'bakes' do
    expect('accounting').to bake_correctly_with_empty_resources
  end
end
