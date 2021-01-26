require 'spec_helper'
require 'ostruct'

RSpec.describe Kitchen::Clipboard do
  let(:my_clipboard) { described_class.new }

  def fake_element(value)
    OpenStruct.new(paste: value)
  end

  context '#add' do
    it 'allows for clipboard calls to be chained' do
      expect(my_clipboard.add(1).add(2).items).to eq([1, 2])
    end

    it 'adds an item to the clipboard' do
      expect(my_clipboard.add(1).items).to eq [1]
    end
  end

  context '#clear' do
    it 'clears clipboard contents' do
      my_clipboard.add(1)
      my_clipboard.clear
      expect(my_clipboard.items).to eq []
    end
  end

  context '#paste' do
    it 'returns a concatenation of the pasting' do
      my_clipboard.add(fake_element(2))
      my_clipboard.add(fake_element(3))
      expect(my_clipboard.paste).to match('23')
    end

    it 'returns empty object when theres nothing to paste' do
      expect(my_clipboard.paste).to eq("")
    end
  end

  context '#each' do
    context 'return self' do
      context 'when the clipboard has contents' do
        before { my_clipboard.add(fake_element(2)) }

        it 'and block is given' do
          expect(my_clipboard.each{}).to be my_clipboard
        end

        it 'and block is not given' do
          expect(my_clipboard.each).to be my_clipboard
        end
      end

      it 'when the clipboard is empty' do
        expect(my_clipboard.each).to be my_clipboard
      end

      it 'when clipboard is not empty and no block is given' do
        my_clipboard.add(2)
        expect(my_clipboard.each).to be my_clipboard
      end
    end

    it 'iterates on elements' do
      my_clipboard.add("howdy").add("y'all")
      expect{ |block| my_clipboard.each(&block) }.to yield_successive_args("howdy", "y'all")
    end
  end

  context '#sort_by' do
    it 'returns empty object when no block given' do
      expect(my_clipboard.sort_by!).to be my_clipboard
    end

    it 'returns sorted object when block given' do
      my_clipboard.add(fake_element('Zebra'))
      my_clipboard.add(fake_element('ABC'))
      my_clipboard.add(fake_element('Element'))
      expect(
        my_clipboard.sort_by!(&:paste).paste
      ).to eq("ABCElementZebra")
    end
  end
end
