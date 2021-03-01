# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Kitchen::Utils do
  describe '.search_path_to_type' do
    it 'converts a search path to an element type' do
      blt = ['bread', ['bacon', 'lettuce & tomato']]
      expect(described_class.search_path_to_type(blt)).to eq('bread,bacon,lettuce & tomato')
    end
  end
end
