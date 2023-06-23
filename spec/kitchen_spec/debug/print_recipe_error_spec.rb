# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'

RSpec.describe 'print_recipe_error' do
  let(:xml) do
    Nokogiri::XML(
      <<~HTML
        <html>
          <body>
            <div data-type="metadata">
              <span data-type="slug" data-value="bar"/>
            </div>
            <div class="hi">Howdy</div>
          </body>
        </html>
      HTML
    )
  end

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
      Kitchen::Oven.bake(input_file: input_file.path,
                         recipes: [recipe],
                         output_file: Tempfile.new.path)
    rescue SystemExit
      # So we don't exit
    end
  end

  it 'prints the error message' do
    expect(output).to match("The recipe has an error: undefined method `foo'")
  end

  # Broken with Ruby 3 & Nokogiri updates
  # Error is now TOO verbose
  #  it 'makes a suggestion' do
  #   expect(output).to match(/Did you mean\?  for/)
  # end

  it 'prints lines from the recipe' do
    expect(output)
      .to match(/at or near/)
      .and match(/spec\/debug\/print_recipe_error_spec.rb/)
      .and match(/9|\s+document\.foo/)
  end

  it 'says how to get the full backtrace' do
    expect(output).to match(/enable by setting the VERBOSE/)
  end

  it 'gives the full backtrace when VERBOSE is set' do
    allow(Kitchen::Debug).to receive(:verbose?).and_return(true)
    expect(output).to match(/Full backtrace:\s+.*print_recipe_error_spec/)
  end

  it 'prints document slag and fix suggestion' do
    expect(output)
      .to match('Something is missing for bar collection!')
      .and match('Please check if the element related with document direction is properly formatted or tagged.')
  end

  context 'when error encountered within a document' do
    let(:recipe) do
      Kitchen::Recipe.new do |document|
        document.search('div').search('ol').first!
      end
    end

    it 'prints the line in the document where the error happened' do
      expect(output)
        .to match('Encountered on line 7')
        .and match('<div class="hi">...</div>')
    end
  end
end
