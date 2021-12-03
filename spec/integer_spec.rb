# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Integer do
  describe '#to_format' do
    it 'returns self if format is arabic' do
      expect(3.to_format(:arabic)).to eq('3')
      expect(11.to_format(:arabic)).to eq('11')
    end

    it 'converts to roman numerals' do
      expect(3.to_format(:roman)).to eq('iii')
      expect(54.to_format(:roman)).to eq('liv')
      expect(96.to_format(:roman)).to eq('xcvi')
      expect {
        101.to_format(:roman)
      }.to raise_error('Unknown conversion to Roman numerals')
    end

    it 'freaks out with unknown case' do
      expect {
        3.to_format(:foo)
      }.to raise_error('Unknown integer format')
    end
  end
end
