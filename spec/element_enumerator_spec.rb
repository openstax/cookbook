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

  let(:element_1_enumerator) { described_class.new {|block| block.yield(element_1)} }

  it "iterates over one element" do
    expect(element_1_enumerator.map(&:name)).to eq %w(div)
  end

  context "#search" do
    it "iterates over all children" do
      expect(element_1_enumerator.search("*").map(&:id)).to eq %w(id1 id2 id3 id4)
    end

    it "iterates over selected children" do
      expect(element_1_enumerator.search("p").map(&:id)).to eq %w(id1 id2 id4)
    end
  end

  context "#cut" do
    let(:enumerator) { element_1_enumerator.search("p") }

    it "can cut to a named clipboard" do
      enumerator.cut(to: :something)
      expect(element_1.to_s).not_to match(/id1|id2|id4/)
      expect(element_1.to_s).to match(/id3/)
      expect(element_1.document.clipboard(name: :something).paste).to match(/id1.*id2[^3]*id4/)
    end

    it "can cut to a new clipboard" do
      clipboard = enumerator.cut
      expect(element_1.to_s).not_to match(/id1|id2|id4/)
      expect(element_1.to_s).to match(/id3/)
      expect(clipboard.paste).to match(/id1.*id2[^3]*id4/)
    end

    it "can cut to an existing clipboard" do
      clipboard = Kitchen::Clipboard.new
      enumerator.cut(to: clipboard)
      expect(element_1.to_s).not_to match(/id1|id2|id4/)
      expect(element_1.to_s).to match(/id3/)
      expect(clipboard.paste).to match(/id1.*id2[^3]*id4/)
    end
  end

  context "#copy" do
    let(:enumerator) { element_1_enumerator.search("p") }
    let(:original_element_1_string) { element_1.to_s }

    it "can copy to a named clipboard" do
      enumerator.copy(to: :something)
      expect(element_1.to_s).to eq original_element_1_string
      expect(element_1.document.clipboard(name: :something).paste).to match(/id1.*id2[^3]*id4/)
    end

    it "can copy to a new clipboard" do
      clipboard = enumerator.copy
      expect(element_1.to_s).to eq original_element_1_string
      expect(clipboard.paste).to match(/id1.*id2[^3]*id4/)
    end

    it "can copy to an existing clipboard" do
      clipboard = Kitchen::Clipboard.new
      enumerator.copy(to: clipboard)
      expect(element_1.to_s).to eq original_element_1_string
      expect(clipboard.paste).to match(/id1.*id2[^3]*id4/)
    end
  end

end
