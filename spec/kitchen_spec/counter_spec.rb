# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Counter do
  let(:instance) { described_class.new }

  describe '.initialize' do
    it 'creates a counter' do
      expect(described_class.new).to be_truthy
    end
  end

  describe '.increment' do
    it 'increments by 1 given no args' do
      expect { instance.increment }.to change(instance, :get).from(0).to(1)
    end

    it 'increments by 2' do
      expect { instance.increment(by: 2) }.to change(instance, :get).from(0).to(2)
    end

    it 'increments by -5' do
      expect { instance.increment(by: -5) }.to change(instance, :get).from(0).to(-5)
    end
  end

  describe '.reset' do
    it 'resets to zero given no args' do
      instance.increment
      instance.reset
      expect(instance.get).to eq(0)
    end

    it 'resets to a given value' do
      instance.reset(to: 4)
      expect(instance.get).to eq(4)
    end
  end
end
