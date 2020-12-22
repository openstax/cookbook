require 'spec_helper'

RSpec.describe Kitchen::SearchHistory do
  context 'empty' do
    it 'converts to an empty array' do
      expect(described_class.empty.to_a).to eq []
    end
  end

  context '#to_s' do
    it 'works' do
      expect(described_class.empty.add(nil).add("foo").add([".blah",".bar"]).to_s).to eq "[?] [foo] [.blah, .bar]"
    end
  end
end
