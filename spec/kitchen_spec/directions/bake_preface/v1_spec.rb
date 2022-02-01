# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakePreface::V1 do
  let(:book1) do
    book_containing(html:
      <<~HTML
        <div data-type="page" class="preface">
          <div data-type="document-title">Preface</div>
          <div data-type="metadata">
            <div data-type="document-title">Preface</div>
          </div>
        </div>
        <div data-type="page" class="preface">
          <div data-type="document-title">Preface</div>
          <div class="description" data-type="description" itemprop="description">description</div>
          <div data-type="metadata">
            <div data-type="document-title">Preface</div>
          </div>
          <div data-type="abstract" id="abcde">abstract</div>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.new.bake(book: book1, title_element: 'h1')

    expected = <<~HTML
      <div class="preface" data-type="page">
        <h1 data-type="document-title">
          <span class="os-text" data-type="" itemprop="">Preface</span>
        </h1>
        <div data-type="metadata">
          <h1 data-type="document-title">
            <span class="os-text" data-type="" itemprop="">Preface</span>
          </h1>
        </div>
      </div>
    HTML

    expect(book1.search('div.preface')).to all(match_normalized_html(expected))
  end
end
