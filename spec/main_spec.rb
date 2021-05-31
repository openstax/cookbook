# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'books' do
  it 'bakes dummy' do
    expect('dummy').to bake_correctly
  end

  it 'bakes chemistry' do
    expect('chemistry').to bake_correctly
  end

  it 'bakes calculus' do
    expect('calculus').to bake_correctly
  end

  it 'bakes u-physics' do
    expect('u-physics').to bake_correctly
  end
end
