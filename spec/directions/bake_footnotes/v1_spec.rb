# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeFootnotes::V1 do

  let(:book1) do
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
            <p><em><a href="#aside3" role="doc-noteref">[footnote]</a> Blah.</em></p>
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
          <div data-type="composite-chapter">
            <div data-type="composite-page">
              <p><a href="#aside7" role="doc-noteref">[footnote]</a> Blah.</p>
              <aside id="aside7" type="footnote">Footnote content 7</aside>
            </div>
            <div data-type="composite-page">
              <p><a href="#aside8" role="doc-noteref">[footnote]</a> Blah.</p>
              <aside id="aside8" type="footnote">Footnote content 8</aside>
            </div>
          </div>
        </div>
        <div data-type="page">
          <p><a href="#aside6" role="doc-noteref">[footnote]</a> Blah.</p>
          <aside id="aside6" type="footnote">Footnote content 6</aside>
        </div>
      HTML
    )
  end

  it 'works with arabic numerals' do
    described_class.new.bake(book: book1)

    expect(book1.body.children.to_s).to match_normalized_html(
      <<~HTML
        <div data-type="page">
          <p class="has-noteref"><a href="#aside1" role="doc-noteref">1</a> Blah.</p>
          <aside id="aside1" type="footnote"><div data-type="footnote-number">1</div>Footnote content 1</aside>
        </div>
        <div data-type="chapter">
          <div data-type="page">
            <p class="has-noteref"><a href="#aside2" role="doc-noteref">1</a> Blah.</p>
            <aside id="aside2" type="footnote"><div data-type="footnote-number">1</div>Footnote content 2</aside>
            <p class="has-noteref"><em><a href="#aside3" role="doc-noteref">2</a> Blah.</em></p>
            <aside id="aside3" type="footnote"><div data-type="footnote-number">2</div>Footnote content 3</aside>
          </div>
          <div data-type="page">
            <p class="has-noteref"><a href="#aside4" role="doc-noteref">3</a> Blah.</p>
            <aside id="aside4" type="footnote"><div data-type="footnote-number">3</div>Footnote content 4</aside>
          </div>
          <div data-type="composite-page">
            <p class="has-noteref"><a href="#aside5" role="doc-noteref">4</a> Blah.</p>
            <aside id="aside5" type="footnote"><div data-type="footnote-number">4</div>Footnote content 5</aside>
          </div>
          <div data-type="composite-chapter">
            <div data-type="composite-page">
              <p class="has-noteref"><a href="#aside7" role="doc-noteref">5</a> Blah.</p>
              <aside id="aside7" type="footnote"><div data-type="footnote-number">5</div>Footnote content 7</aside>
            </div>
            <div data-type="composite-page">
              <p class="has-noteref"><a href="#aside8" role="doc-noteref">6</a> Blah.</p>
              <aside id="aside8" type="footnote"><div data-type="footnote-number">6</div>Footnote content 8</aside>
            </div>
          </div>
        </div>
        <div data-type="page">
          <p class="has-noteref"><a href="#aside6" role="doc-noteref">1</a> Blah.</p>
          <aside id="aside6" type="footnote"><div data-type="footnote-number">1</div>Footnote content 6</aside>
        </div>
      HTML
    )
  end

  it 'works with roman numerals' do
    described_class.new.bake(book: book1, number_format: :roman)

    expect(book1.body.children.to_s).to match_normalized_html(
      <<~HTML
        <div data-type="page">
          <p class="has-noteref"><a href="#aside1" role="doc-noteref">i</a> Blah.</p>
          <aside id="aside1" type="footnote"><div data-type="footnote-number">i</div>Footnote content 1</aside>
        </div>
        <div data-type="chapter">
          <div data-type="page">
            <p class="has-noteref"><a href="#aside2" role="doc-noteref">i</a> Blah.</p>
            <aside id="aside2" type="footnote"><div data-type="footnote-number">i</div>Footnote content 2</aside>
            <p class="has-noteref"><em><a href="#aside3" role="doc-noteref">ii</a> Blah.</em></p>
            <aside id="aside3" type="footnote"><div data-type="footnote-number">ii</div>Footnote content 3</aside>
          </div>
          <div data-type="page">
            <p class="has-noteref"><a href="#aside4" role="doc-noteref">iii</a> Blah.</p>
            <aside id="aside4" type="footnote"><div data-type="footnote-number">iii</div>Footnote content 4</aside>
          </div>
          <div data-type="composite-page">
            <p class="has-noteref"><a href="#aside5" role="doc-noteref">iv</a> Blah.</p>
            <aside id="aside5" type="footnote"><div data-type="footnote-number">iv</div>Footnote content 5</aside>
          </div>
          <div data-type="composite-chapter">
            <div data-type="composite-page">
              <p class="has-noteref"><a href="#aside7" role="doc-noteref">v</a> Blah.</p>
              <aside id="aside7" type="footnote"><div data-type="footnote-number">v</div>Footnote content 7</aside>
            </div>
            <div data-type="composite-page">
              <p class="has-noteref"><a href="#aside8" role="doc-noteref">vi</a> Blah.</p>
              <aside id="aside8" type="footnote"><div data-type="footnote-number">vi</div>Footnote content 8</aside>
            </div>
          </div>
        </div>
        <div data-type="page">
          <p class="has-noteref"><a href="#aside6" role="doc-noteref">i</a> Blah.</p>
          <aside id="aside6" type="footnote"><div data-type="footnote-number">i</div>Footnote content 6</aside>
        </div>
      HTML
    )
  end

end
