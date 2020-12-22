require 'spec_helper'

RSpec.describe Kitchen::ElementEnumeratorFactory do
  context 'apply_default_css_or_xpath_and_normalize' do
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
end
