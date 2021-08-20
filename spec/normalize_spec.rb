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

  let(:doc_with_duplicate_ids) do
    Nokogiri::XML(
      <<~HTML
        <body>
          <div id="duplicate1"/>
          <div id="unique">
            <div id="duplicate1"/>
            <div id="publisher-1"/>
          </div>
          <div id="publisher-1"/>
          <div>
            <div>
              <div>
                <div id="duplicate1">
              </div>
            </div>
          </div>
        </body>
      HTML
    )
  end

  it 'normalizes' do
    normalize(doc)
    expect(doc.to_xml).to eq(expected_output.to_xml)
  end

  it 'warns about duplicate ids' do
    expect($stdout).to receive(:puts).with('warning! duplicate id found for duplicate1').twice
    normalize(doc_with_duplicate_ids)
  end

  describe '#mask_term_numbers' do
    let(:doc_with_terms) do
      Nokogiri::XML(
        <<~HTML
          <body>
            <span data-type="term" id="auto_123456_term471"/>
            <a class="os-term-section-link" href="#auto_123456_term168">
          </body>
        HTML
      )
    end

    let(:doc_with_terms_masked) do
      Nokogiri::XML(
        <<~HTML
          <body>
            <span data-type="term" id="auto_123456_termXXX"/>
            <a class="os-term-section-link" href="#auto_123456_termXXX">
          </body>
        HTML
      )
    end

    it 'does nothing when argument not given' do
      normalize(doc_with_terms)
      expect(doc_with_terms.to_xml).to eq(doc_with_terms.to_xml)
    end

    it 'masks terms' do
      normalize(doc_with_terms, args: ['--mask-terms', 'abc'])
      expect(doc_with_terms.to_xml).to eq(doc_with_terms_masked.to_xml)
    end
  end
end
