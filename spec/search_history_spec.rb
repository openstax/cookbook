require 'spec_helper'

RSpec.describe Kitchen::SearchHistory do
  context 'init' do
    it 'creates instance variables' do
      sh = described_class.new('foo', 'bar')
      expect(sh.upstream).to eq('foo')
      expect(sh.latest).to eq('bar')
    end
  end

  context 'empty' do
    it 'converts to an empty array' do
      expect(described_class.empty.to_a).to eq []
    end
  end

  describe '#add' do
    it 'adds nil if given nil value' do
      expect(described_class.empty.add(nil).latest).to be_nil
    end
  end

  describe '#to_s' do
    it 'works' do
      expect(described_class.empty.add(nil).add('foo').add(['.blah', '.bar']).to_s).to eq '[?] [foo] [.blah, .bar]'
    end
  end

  describe '#to_a' do
    it 'returns [latest] if no upstream' do
      expect(described_class.empty.add('foo').to_a).to eq(['foo'])
    end

    it 'returns array with upstream and latest' do
      expect(described_class.empty.add('foo').add(%w[blah bar]).add(['baz']).to_a).to eq(['foo', 'blah, bar', 'baz'])
    end
  end

  describe '#empty?' do
    it 'returns true if empty' do
      expect(described_class.empty).to be_empty
    end

    it 'returns false if not empty' do
      expect(described_class.empty.add('foo')).not_to be_empty
    end
  end
end
