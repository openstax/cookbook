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

  describe 'Nokogiri::XML::Document' do
    it 'can alphabetize attributes by key' do
      document.alphabetize_attributes!
      expect(document.to_s.gsub("\n", '')).to match(/class.*style.*blah.*data-type/)
    end

    it 'does not print the whole document when inspected' do
      expect(document.inspect).not_to match(/div/)
    end
  end

  describe 'Nokogiri::XML::Node' do
    it 'prints to string when inspected' do
      expect_any_instance_of(Nokogiri::XML::Node).to receive(:to_s)
      document.search('div').first.inspect
    end

    it 'gives an array of classes' do
      expect(make_nokogiri_node('<div class="foo"/>').classes).to eq ['foo']
      expect(make_nokogiri_node('<div class="foo bar"/>').classes).to eq %w[foo bar]
      expect(make_nokogiri_node('<div/>').classes).to eq []
    end

    describe '#quick_matches?' do
      it 'works for simple name selectors' do
        expect(make_nokogiri_node('<div/>').quick_matches?('div')).to be true
        expect(make_nokogiri_node('<div/>').quick_matches?('span')).to be false
      end

      it 'works for simple name selectors with a class' do
        expect(make_nokogiri_node('<div class="bar foo"/>').quick_matches?('div.foo')).to be true
        expect(make_nokogiri_node('<div class="bar foo"/>').quick_matches?('div.bar')).to be true
        expect(make_nokogiri_node('<div class="bar foo"/>').quick_matches?('div.blah')).to be false
      end

      it 'does not explode for class selectors when there is no class' do
        expect(make_nokogiri_node('<div/>').quick_matches?('div.foo')).to be false
      end

      it 'works for attributes with element name' do
        expect(make_nokogiri_node('<div data-type="foo"/>').quick_matches?('div[data-type="foo"]')).to be true
        expect(make_nokogiri_node('<div data-type="foo"/>').quick_matches?('div[data-type="bar"]')).to be false
      end

      it 'works for attributes without element name' do
        expect(make_nokogiri_node('<div data-type="foo"/>').quick_matches?('[data-type="foo"]')).to be true
        expect(make_nokogiri_node('<div data-type="foo"/>').quick_matches?('[data-type="bar"]')).to be false
      end

      it 'works for multiple selectors' do
        expect(make_nokogiri_node('<div class="bar"/>').quick_matches?('.foo, .bar')).to be true
        expect(make_nokogiri_node('<div class="bar"/>').quick_matches?('.foo, .blah')).to be false
      end

      it 'freaks out if it gets a type it does not know' do
        expect {
          make_nokogiri_node('<div class="bar"/>').quick_matches?('.foo > .bar')
        }.to raise_error(/Unknown.*type/)
      end
    end
  end

  def make_nokogiri_node(string)
    Nokogiri::XML(
      <<~XML
        <div>
          #{string}
        </div>
      XML
    ).search('div').first.element_children.first
  end
end
