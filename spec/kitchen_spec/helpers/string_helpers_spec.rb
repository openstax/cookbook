# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'

RSpec.describe StringHelpers do
  let(:xml) do
    Nokogiri::XML(
      <<~HTML
        <html>
          <body>
            <div data-type="metadata">
              <span data-type="slug" data-value="foo"/>
            </div>
            <div class='hi'>Howdy</div>
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

  def output(clear_colors: false)
    input_file = Tempfile.new.tap do |file|
      file.write(xml)
      file.rewind
    end

    with_captured_stdout(clear_colors: clear_colors) do
      Kitchen::Oven.bake(input_file: input_file.path,
                         recipes: [recipe],
                         output_file: Tempfile.new.path)
    rescue SystemExit
      # So we don't exit
    end
  end

  it 'captures string - clear colors' do
    expect(output).to match(/The recipe has an error: /)
  end

  it 'captures plain string' do
    expect(output(clear_colors: true)).to match(/The recipe has an error: /)
  end

end
