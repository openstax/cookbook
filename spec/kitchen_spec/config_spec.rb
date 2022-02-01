# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Config do
  let(:foobar) { described_class.new(hash: {}, selectors: 'foo') }

  describe '.initialize' do
    it 'creates a new Config instance' do
      expect(described_class.new).to be_truthy
    end
  end

  describe '#selectors' do
    it 'reads selectors' do
      expect(foobar.selectors).to eq('foo')
    end
  end

  describe 'self.new_from_file' do
    it "isn't implemented yet" do
      expect { described_class.new_from_file('bleh') }.to raise_error('NYI')
    end
  end

end
