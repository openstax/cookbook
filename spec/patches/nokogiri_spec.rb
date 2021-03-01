# frozen_string_literal: true
RSpec.describe 'Nokogiri patches' do
  let(:document) do
    Nokogiri::XML(
      <<~XML
        <div style='blah' class='hi'>
          <span data-type='foo' blah='howdy'>Hi</span>
        </div>
      XML
  )
  end

  context 'Nokogiri::XML::Document' do
    it 'can alphabetize attributes by key' do
      document.alphabetize_attributes!
      expect(document.to_s.gsub("\n", '')).to match(/class.*style.*blah.*data-type/)
    end

    it 'does not print the whole document when inspected' do
      expect(document.inspect).not_to match(/div/)
    end
  end

  context 'Nokogiri::XML::Node' do
    it 'prints to string when inspected' do
      expect_any_instance_of(Nokogiri::XML::Node).to receive(:to_s)
      document.search('div').first.inspect
    end
  end
end
