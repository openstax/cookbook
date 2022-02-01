# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::SearchHistory do
  let(:foo_query) { Kitchen::SearchQuery.new(css_or_xpath: 'foo') }
  let(:bar_query) { Kitchen::SearchQuery.new(css_or_xpath: 'bar') }
  let(:blah_or_bar_query) { Kitchen::SearchQuery.new(css_or_xpath: ['.blah', '.bar']) }

  describe '#initialize' do
    it 'raises if upstream is not a SearchHistory' do
      expect { described_class.new('foo', nil) }.to raise_error(/must be a SearchHistory/)
    end

    it 'raises if latest is not a SearchQuery' do
      expect { described_class.new(nil, 'bar') }.to raise_error(/must be a SearchQuery/)
    end
  end

  describe 'empty' do
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
      expect(described_class.empty.add(nil)
                                  .add(foo_query)
                                  .add(blah_or_bar_query).to_s).to eq '[foo] [.blah,.bar]'
    end
  end

  describe '#to_a' do
    it 'returns [latest] if no upstream' do
      expect(described_class.empty.add(foo_query).to_a.map(&:to_s)).to eq(['foo'])
    end

    it 'returns array with upstream and latest' do
      expect(described_class.empty.add(foo_query)
                                  .add(blah_or_bar_query)
                                  .add(bar_query).to_a.map(&:to_s)).to eq(['foo', '.blah,.bar', 'bar'])
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
