# frozen_string_literal: true

require 'spec_helper'
require_relative '../scripts/helpers/normalize_helpers'

RSpec.describe 'normalize script' do
  let(:doc) do
    Nokogiri::XML(
      <<~HTML
        <body>
          <div class="" id="abc_copy_1">Hello,World!</div>
          <table class="unnumbered" summary="123456">table</table>
          <table class="" summary="123456">table 2</table>
          <div class=" ccccc   aaa bbb ">stuff</div>
          <div d="4" c="3" a="1"  e="5" b="2"/>
        </body>
      HTML
    )
  end

  let(:expected_output) do
    Nokogiri::XML(
      <<~HTML
        <body>
          <div id="abc_copy_XXX">Hello,World!</div>
          <table class="unnumbered">table</table>
          <table summary="123456">table 2</table>
          <div class="aaa bbb ccccc">stuff</div>
          <div a="1" b="2" c="3" d="4" e="5"/>
        </body>
      HTML
    )
  end

  it 'normalizes' do
    normalize(doc)
    expect(doc.to_xml).to eq(expected_output.to_xml)
  end
end
