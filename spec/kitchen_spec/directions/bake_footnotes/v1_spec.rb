# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeFootnotes::V1 do

  let(:book1) do
    book_containing(html:
      <<~HTML
        <div data-type="page" id="testidOne">
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
          <p><sup><a href="#aside9" role="doc-noteref">[footnote]</a> Blah.</sup></p>
            <aside id="aside9" type="footnote">Footnote content 9</aside>
        </div>
      HTML
    )
  end

  let(:book_with_references) do
    book_containing(html:
      <<~HTML
        <div data-type="page" id="testidOne">
          <p><a href="#aside1" role="doc-noteref">[footnote]</a> Blah.</p>
          <aside id="aside1" type="footnote">Footnote content 1</aside>
        </div>
        <div data-type="chapter">
          <div data-type="page">
            <p><a href="#aside2" role="doc-noteref" class="reference">[footnote]</a> Blah.</p>
            <aside id="aside2" type="footnote" class="reference">Footnote content 2</aside>
            <p><em><a href="#aside3" role="doc-noteref" class="reference">[footnote]</a> Blah.</em></p>
            <aside id="aside3" type="footnote" class="reference">Footnote content 3</aside>
          </div>
          <div data-type="page">
            <p><a href="#aside4" role="doc-noteref" class="reference">[footnote]</a> Blah.</p>
            <aside id="aside4" type="footnote" class="reference">Footnote content 4</aside>
          </div>
          <div data-type="composite-page">
            <p><a href="#aside5" role="doc-noteref" class="reference">[footnote]</a> Blah.</p>
            <aside id="aside5" type="footnote" class="reference">Footnote content 5</aside>
          </div>
          <div data-type="composite-chapter">
            <div data-type="composite-page">
              <p><a href="#aside7" role="doc-noteref" class="reference">[footnote]</a> Blah.</p>
              <aside id="aside7" type="footnote" class="reference">Footnote content 7</aside>
            </div>
            <div data-type="composite-page">
              <p><a href="#aside8" role="doc-noteref">[footnote]</a> Blah.</p>
              <aside id="aside8" type="footnote">Footnote content 8</aside>
            </div>
          </div>
        </div>
      HTML
    )
  end

  it 'works with arabic numerals' do
    described_class.new.bake(book: book1)

    expect(book1.body.children.to_s).to match_snapshot_auto
  end

  it 'works with roman numerals' do
    described_class.new.bake(book: book1, number_format: :roman)

    expect(book1.body.children.to_s).to match_snapshot_auto
  end

  it 'works with selector' do
    described_class.new.bake(book: book_with_references, selector: '.reference')

    expect(book_with_references.body.children.to_s).to match_snapshot_auto
  end

end
