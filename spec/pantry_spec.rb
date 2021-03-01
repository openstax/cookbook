# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Pantry do
  let(:instance) { described_class.new }

  describe 'initialize' do
    it 'creates a pantry object' do
      expect(instance).to be_truthy
    end
  end

  context 'when at least one item is in the pantry' do
    before { instance.store 'bar', label: 'foo' }

    describe '#get' do
      it 'returns a present item with either a string or symbol label' do
        expect(instance.get(:foo)).to eq('bar')
        expect(instance.get('foo')).to eq('bar')
      end

      it 'returns nil when an item is not present' do
        expect(instance.get(:blah)).to be_nil
      end
    end

    describe '#get!' do
      it 'returns a present item with either a string or symbol label' do
        expect(instance.get!(:foo)).to eq('bar')
        expect(instance.get!('foo')).to eq('bar')
      end

      it 'raises if requested item is not in pantry' do
        expect { instance.get!('thud') }.to raise_error(
          Kitchen::RecipeError, "There is no pantry item labeled 'thud'"
        )
      end
    end

    describe '#size' do
      it 'returns the number of items in the pantry' do
        expect(instance.size).to eq(1)
      end
    end

    describe '#each' do
      it 'iterates over the pantry items' do
        instance.store 'baz', label: 'qux'
        expect { |block| instance.each(&block) }.to yield_successive_args([:foo, 'bar'], [:qux, 'baz'])
      end
    end
  end
end
