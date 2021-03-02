# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::ElementEnumeratorFactory do
  describe 'apply_default_css_or_xpath_and_normalize' do
    let(:method) { described_class.method(:apply_default_css_or_xpath_and_normalize) }

    it 'arrayifies a string' do
      expect(method.call(css_or_xpath: 'foo')).to eq ['foo']
    end

    it 'passes through an array' do
      expect(method.call(css_or_xpath: ['foo'])).to eq ['foo']
    end

    it 'replaces $ with default css in a string' do
      expect(method.call(css_or_xpath: '$.hi', default_css_or_xpath: 'div')).to eq ['div.hi']
    end

    it 'replaces $ with default css in an array' do
      expect(method.call(css_or_xpath: ['$.hi', '$#bar'],
                         default_css_or_xpath: 'div')).to eq ['div.hi', 'div#bar']
    end

    it 'clears $ when no default' do
      expect(method.call(css_or_xpath: '$.bar')).to eq ['.bar']
    end

    it 'gives empty string when no css and no default' do
      expect(method.call).to eq ['']
    end

    it 'adds a $ when css nil' do
      expect(method.call(default_css_or_xpath: 'div')).to eq ['div']
    end
  end

  describe 'specific enumerators create a factory' do
    [
      Kitchen::ChapterElementEnumerator,
      Kitchen::CompositePageElementEnumerator,
      Kitchen::ExampleElementEnumerator,
      Kitchen::FigureElementEnumerator,
      Kitchen::NoteElementEnumerator,
      Kitchen::PageElementEnumerator,
      Kitchen::TableElementEnumerator,
      Kitchen::TermElementEnumerator,
      Kitchen::TypeCastingElementEnumerator
    ].each do |enumerator_class|
      it "is created by #{enumerator_class}" do
        expect(described_class).to receive(:new)
        enumerator_class.factory
      end
    end
  end
end
