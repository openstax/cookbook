# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'

RSpec.describe 'print_recipe_error' do
  let(:xml) { "<div class='hi'>Howdy</div>\n" }

  let(:recipe) do
    Kitchen::Recipe.new do |document|
      document.foo
    end
  end

  let(:output) do
    input_file = Tempfile.new.tap do |file|
      file.write(xml)
      file.rewind
    end

    with_captured_stdout(clear_colors: true) do
      begin
        Kitchen::Oven.bake(input_file: input_file.path,
                           recipes: [recipe],
                           output_file: Tempfile.new.path)
      rescue SystemExit
        # So we don't exit
      end
    end
  end

  it 'prints the error message' do
    expect(output).to match("The recipe has an error: undefined method `foo'")
  end

  it 'makes a suggestion' do
    expect(output).to match(/Did you mean\?  for/)
  end

  it 'prints lines from the recipe' do
    expect(output).to match(/at or near/)
    expect(output).to match(/spec\/debug\/print_recipe_error_spec.rb/)
    expect(output).to match(/9|\s+document\.foo/)
  end

  it 'says how to get the full backtrace' do
    expect(output).to match(/enable by setting the VERBOSE/)
  end

  it 'gives the full backtrace when VERBOSE is set' do
    allow(Kitchen::Debug).to receive(:verbose?).and_return(true)
    expect(output).to match(/Full backtrace:\s+.*print_recipe_error_spec/)
  end

  context 'error encountered within a document' do
    let(:recipe) do
      Kitchen::Recipe.new do |document|
        document.search('div').search('span').first!
      end
    end

    it 'prints the line in the document where the error happened' do
      expect(output).to match('Encountered on line 1')
      expect(output).to match('<div class="hi">...</div>')
    end
  end
end
