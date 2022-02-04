# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Array do
  describe 'Prefix' do
    it 'adds string at the beginning of each string inside array' do
      expect(%w[a b].prefix('section.')).to eq(%w[section.a section.b])
    end
  end
end
