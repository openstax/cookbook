# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Document do
  let(:lang) { nil }

  let(:xml) do
    Nokogiri::XML(
      <<~HTML
        <html #{"lang=\"#{lang}\"" if lang}>
          <body>
            <div class='hi'>Howdy</div>
          </body>
        </html>
      HTML
    )
  end

  let(:instance) { described_class.new(nokogiri_document: xml) }

  it 'counter works' do
    expect(instance.counter(:chapter).get).to eq(0)
  end

  it 'creates element' do
    expect(instance.create_element('div', class: 'foo')).to match_normalized_html(
      <<~HTML
        <div class="foo"/>
      HTML
    )
  end

  describe('#create_element_from_string') do
    it 'creates a simple element' do
      expect(
        instance.create_element_from_string("<div class='foo'>bar</div>")
      ).to match_normalized_html(
        <<~HTML
          <div class="foo">bar</div>
        HTML
      )
    end

    it 'returns an element in the document that receives the call' do
      expect(instance.create_element_from_string("<div class='foo'>bar</div>").document).to eq instance
    end

    it 'creates an element with child elements' do
      expect(
        instance.create_element_from_string("<div class='foo'><span>bar</span></div>")
      ).to match_normalized_html(
        <<~HTML
          <div class="foo">
            <span>bar</span>
          </div>
        HTML
      )
    end

    it 'raises when the string has more than one top-level element' do
      expect { instance.create_element_from_string('<div></div><span></span>') }.to raise_error(/one top-level/)
    end
  end

  describe('#locale') do
    context 'when lang is present' do
      let(:lang) { 'pl' }

      it 'returns pl' do
        expect(instance.locale).to eq :pl
      end
    end

    context 'when lang is absent' do
      it 'defaults to en' do
        expect(Warning).to receive(:warn).with(/No `lang`/)
        expect(instance.locale).to eq :en
      end
    end

  end
end
