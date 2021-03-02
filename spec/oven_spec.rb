# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'

RSpec.describe Kitchen::Oven do
  describe 'BakeProfile' do
    it 'can be written to string' do
      expect(Kitchen::Oven::BakeProfile.new.to_s).to eq <<~STRING
        Open:  ?? s
        Parse: ?? s
        Bake:  ?? s
        Write: ?? s
      STRING
    end
  end

  describe '#bake' do
    it 'does nada when there are no recipes' do
      input_file = Tempfile.new.tap { |file| file.write("<div>Howdy</div>\n"); file.rewind }
      output_file = Tempfile.new

      described_class.bake(input_file: input_file.path, recipes: [], output_file: output_file.path)
      expect(output_file.read).to eq "<div>Howdy</div>\n"
    end

    it 'bakes' do
      input_file = Tempfile.new.tap { |file| file.write("<div>Howdy</div>\n"); file.rewind }
      output_file = Tempfile.new

      recipe = Kitchen::Recipe.new do |document|
        document.search('div').first.name = 'booyah'
      end

      described_class.bake(input_file: input_file.path, recipes: [recipe], output_file: output_file.path)
      expect(output_file.read).to eq "<booyah>Howdy</booyah>\n"
    end
  end
end
