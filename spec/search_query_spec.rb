# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::SearchQuery do
  let(:css_or_xpath) { nil }
  let(:only) { nil }
  let(:except) { nil }
  let(:instance) { described_class.new(css_or_xpath: css_or_xpath, only: only, except: except) }

  describe '#apply_default_css_or_xpath_and_normalize' do
    it 'arrayifies a string' do
      expect_normalization(css_or_xpath: 'foo', to: ['foo'])
    end

    it 'passes through an array' do
      expect_normalization(css_or_xpath: ['foo'], to: ['foo'])
    end

    it 'replaces $ with default css in a string' do
      expect_normalization(css_or_xpath: '$.hi', default_css_or_xpath: 'div', to: ['div.hi'])
    end

    it 'replaces $ with default css in an array' do
      expect_normalization(css_or_xpath: ['$.hi', '$#bar'], default_css_or_xpath: 'div', to: ['div.hi', 'div#bar'])
    end

    it 'clears $ when no default' do
      expect_normalization(css_or_xpath: '$.bar', to: ['.bar'])
    end

    it 'gives empty string when no css and no default' do
      expect_normalization(to: [''])
    end

    it 'adds a $ when css nil' do
      expect_normalization(default_css_or_xpath: 'div', to: ['div'])
    end
  end

  def expect_normalization(to:, css_or_xpath: nil, default_css_or_xpath: nil)
    instance = described_class.new(css_or_xpath: css_or_xpath)
    instance.apply_default_css_or_xpath_and_normalize(default_css_or_xpath)
    expect(instance.css_or_xpath).to eq to
  end

  describe '#conditions_match?' do
    let(:element_with_id) { new_element('<div id="divId"/>') }
    let(:element_without_id) { new_element('<div/>') }

    context 'when neither only nor except are given' do
      it 'returns true' do
        expect(instance.conditions_match?(element_with_id)).to eq true
      end
    end

    context 'when only is a symbol' do
      let(:only) { :id }

      it 'returns true when the method returns truthy' do
        expect(instance.conditions_match?(element_with_id)).to eq true
      end

      it 'returns false when the method returns falsy' do
        expect(instance.conditions_match?(element_without_id)).to eq false
      end
    end

    context 'when only is a callable' do
      let(:only) { ->(element) { element.id } }

      it 'returns true when the callable returns truthy' do
        expect(instance.conditions_match?(element_with_id)).to eq true
      end

      it 'returns false when the callable returns falsy' do
        expect(instance.conditions_match?(element_without_id)).to eq false
      end
    end

    context 'when except is a symbol' do
      let(:except) { :id }

      it 'returns false when the method returns truthy' do
        expect(instance.conditions_match?(element_with_id)).to eq false
      end

      it 'returns true when the method returns falsy' do
        expect(instance.conditions_match?(element_without_id)).to eq true
      end
    end

    context 'when except is a callable' do
      let(:except) { ->(element) { element.id } }

      it 'returns false when the callable returns truthy' do
        expect(instance.conditions_match?(element_with_id)).to eq false
      end

      it 'returns true when the callable returns falsy' do
        expect(instance.conditions_match?(element_without_id)).to eq true
      end
    end

    context 'when both only and except given' do
      [
        [false, false, false],
        [false, true, false],
        [true, false, true],
        [true, true, false]
      ].each do |only_return, except_return, overall_return|
        context "when only returns #{only_return} and except returns #{except_return}" do
          let(:only) { ->(_) { only_return } }
          let(:except) { ->(_) { except_return } }

          it "returns #{overall_return}" do
            expect(instance.conditions_match?(element_without_id)).to eq overall_return
          end
        end
      end
    end
  end

end
