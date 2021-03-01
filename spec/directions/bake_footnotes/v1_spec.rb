# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeFootnotes::V1 do

  let(:book_1) do
    book_containing(html:
      <<~HTML
        <div data-type="page">
          <p><a href="#aside1" role="doc-noteref">[footnote]</a> Blah.</p>
          <aside id="aside1" type="footnote">Footnote content 1</aside>
        </div>
        <div data-type="chapter">
          <div data-type="page">
            <p><a href="#aside2" role="doc-noteref">[footnote]</a> Blah.</p>
            <aside id="aside2" type="footnote">Footnote content 2</aside>
            <p><a href="#aside3" role="doc-noteref">[footnote]</a> Blah.</p>
            <aside id="aside3" type="footnote">Footnote content 3</aside>
          </div>
          <div data-type="page">
            <p><a href="#aside4" role="doc-noteref">[footnote]</a> Blah.</p>
            <aside id="aside4" type="footnote">Footnote content 4</aside>
          </div>
          <div data-type="composite-page">
            <p><a href="#aside5" role="doc-noteref">[footnote]</a> Blah.</p>
            <aside id="aside5" type="footnote">Footnote content 5</aside>
          </div>
        </div>
        <div data-type="page">
          <p><a href="#aside6" role="doc-noteref">[footnote]</a> Blah.</p>
          <aside id="aside6" type="footnote">Footnote content 6</aside>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.new.bake(book: book_1)

    expect(book_1.body.children.to_s).to match_normalized_html(
      <<~HTML
        <div data-type="page">
          <p><a href="#aside1" role="doc-noteref">1</a> Blah.</p>
          <aside id="aside1" type="footnote"><div data-type="footnote-number">1</div>Footnote content 1</aside>
        </div>
        <div data-type="chapter">
          <div data-type="page">
            <p><a href="#aside2" role="doc-noteref">1</a> Blah.</p>
            <aside id="aside2" type="footnote"><div data-type="footnote-number">1</div>Footnote content 2</aside>
            <p><a href="#aside3" role="doc-noteref">2</a> Blah.</p>
            <aside id="aside3" type="footnote"><div data-type="footnote-number">2</div>Footnote content 3</aside>
          </div>
          <div data-type="page">
            <p><a href="#aside4" role="doc-noteref">3</a> Blah.</p>
            <aside id="aside4" type="footnote"><div data-type="footnote-number">3</div>Footnote content 4</aside>
          </div>
          <div data-type="composite-page">
            <p><a href="#aside5" role="doc-noteref">4</a> Blah.</p>
            <aside id="aside5" type="footnote"><div data-type="footnote-number">4</div>Footnote content 5</aside>
          </div>
        </div>
        <div data-type="page">
          <p><a href="#aside6" role="doc-noteref">1</a> Blah.</p>
          <aside id="aside6" type="footnote"><div data-type="footnote-number">1</div>Footnote content 6</aside>
        </div>
      HTML
    )

  end

end
