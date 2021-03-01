require 'spec_helper'

RSpec.describe Kitchen::ElementEnumerator do

  let(:element_1) do
    new_element(
      <<~HTML
        <div id="divId">
          <p id="id1">One</p>
          <p id="id2">Two</p>
          <span id="id3">Three</span>
          <p id="id4">Four</p>
        </div>
      HTML
    )
  end

  let(:element_1_enumerator) { described_class.new { |block| block.yield(element_1) } }

  let(:element_2) do
    new_element(
      <<~HTML
        <div id="divId">
          <div class="foo">
            <p id="pId">
              <span>Blah</span>
            </p>
          </div>
        </div>
      HTML
    )
  end

  let(:element_2_enumerator) { described_class.new { |block| block.yield(element_2) } }

  it 'iterates over one element' do
    expect(element_1_enumerator.map(&:name)).to eq %w[div]
  end

  describe '#search' do
    it 'iterates over all children' do
      expect(element_1_enumerator.search('*').map(&:id)).to eq %w[id1 id2 id3 id4]
    end

    it 'iterates over selected children' do
      expect(element_1_enumerator.search('p').map(&:id)).to eq %w[id1 id2 id4]
    end
  end

  describe '#cut' do
    let(:enumerator) { element_1_enumerator.search('p') }

    it 'can cut to a named clipboard' do
      enumerator.cut(to: :something)
      expect(element_1.to_s).not_to match(/id1|id2|id4/)
      expect(element_1.to_s).to match(/id3/)
      expect(element_1.document.clipboard(name: :something).paste).to match(/id1.*id2[^3]*id4/)
    end

    it 'can cut to a new clipboard' do
      clipboard = enumerator.cut
      expect(element_1.to_s).not_to match(/id1|id2|id4/)
      expect(element_1.to_s).to match(/id3/)
      expect(clipboard.paste).to match(/id1.*id2[^3]*id4/)
    end

    it 'can cut to an existing clipboard' do
      clipboard = Kitchen::Clipboard.new
      enumerator.cut(to: clipboard)
      expect(element_1.to_s).not_to match(/id1|id2|id4/)
      expect(element_1.to_s).to match(/id3/)
      expect(clipboard.paste).to match(/id1.*id2[^3]*id4/)
    end
  end

  describe '#copy' do
    let(:enumerator) { element_1_enumerator.search('p') }
    let(:original_element_1_string) { element_1.to_s }

    it 'can copy to a named clipboard' do
      enumerator.copy(to: :something)
      expect(element_1.to_s).to eq original_element_1_string
      expect(element_1.document.clipboard(name: :something).paste).to match(/id1.*id2[^3]*id4/)
    end

    it 'can copy to a new clipboard' do
      clipboard = enumerator.copy
      expect(element_1.to_s).to eq original_element_1_string
      expect(clipboard.paste).to match(/id1.*id2[^3]*id4/)
    end

    it 'can copy to an existing clipboard' do
      clipboard = Kitchen::Clipboard.new
      enumerator.copy(to: clipboard)
      expect(element_1.to_s).to eq original_element_1_string
      expect(clipboard.paste).to match(/id1.*id2[^3]*id4/)
    end
  end

  describe '#search_history' do
    it 'works' do
      chained_enumerator = element_2_enumerator.search('.foo').search('#pId').search('span')
      expect(chained_enumerator.search_history.to_s).to eq '[?] [.foo] [#pId] [span]'
    end
  end

  describe '#first!' do
    it 'gives a meaningful error message when it bombs' do
      expect {
        element_2_enumerator.search('.foo').search('#blah').first!
      }.to raise_error(/not return a first result matching #blah inside .*\.foo/)
    end
  end

end
