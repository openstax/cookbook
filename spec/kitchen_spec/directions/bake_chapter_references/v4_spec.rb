# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterReferences::V4 do

  before do
    stub_locales({
      'eoc': {
        'references': 'References'
      }
    })
  end

  let(:chapter) do
    chapter_element(
      <<~HTML
        <div data-type="page">
          <p class="has-noteref"><a href="#aside2" role="doc-noteref" class="reference" id="aside2-a">1</a> Blah.</p>
          <aside id="aside2" type="footnote" class="reference"><a href="#aside2-a" data-type="footnote-number">1.</a><span>Footnote content 2</span></aside>
          <p class="has-noteref"><em><a href="#aside3" role="doc-noteref" class="reference" id="aside3-a">2</a> Blah.</em></p>
          <aside id="aside3" type="footnote" class="reference"><a href="#aside3-a" data-type="footnote-number">2.</a><span>Footnote content 3</span></aside>
        </div>
        <div data-type="page">
          <p class="has-noteref"><a href="#aside4" role="doc-noteref" class="reference" id="aside4-a">3</a> Blah.</p>
          <aside id="aside4" type="footnote" class="reference"><a href="#aside4-a" data-type="footnote-number">3.</a><span>Footnote content 4</span></aside>
        </div>
        <div data-type="composite-page">
          <p class="has-noteref"><a href="#aside5" role="doc-noteref" class="reference" id="aside5-a">4</a> Blah.</p>
          <aside id="aside5" type="footnote" class="reference"><a href="#aside5-a" data-type="footnote-number">4.</a><span>Footnote content 5</span></aside>
        </div>
        <div data-type="composite-chapter">
          <div data-type="composite-page">
            <p class="has-noteref"><a href="#aside7" role="doc-noteref" class="reference" id="aside7-a">5</a> Blah.</p>
            <aside id="aside7" type="footnote" class="reference"><a href="#aside7-a" data-type="footnote-number">5.</a><span>Footnote content 7</span></aside>
          </div>
          <div data-type="composite-page">
            <p><a href="#aside8" role="doc-noteref">[footnote]</a> Blah.</p>
            <aside id="aside8" type="footnote">Footnote content 8</aside>
          </div>
        </div>
      HTML
    )
  end

  it 'works' do
    chapter.selectors.override(
      reference: 'aside.reference'
    )
    described_class.new.bake(chapter: chapter, metadata_source: metadata_element)
    expect(chapter).to match_snapshot_auto
  end
end
