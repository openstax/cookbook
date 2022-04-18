# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterReferences::V2 do

  before do
    stub_locales({
      'eoc': {
        'references': 'Endnotes'
      }
    })
  end

  let(:chapter) do
    chapter_element(
      <<~HTML
        <div data-type="page" id="page1">
          <h1 data-type='document-title'>Introduction to Sociology</h1>
          <p>Some text
            <a href="#something" data-type="cite" id="some-id">
              <div data-type="note" class="delete-me">
                <!-- no-selfclose -->
              </div>
            </a>
          </p>
          <section data-depth="1" id="1" class="reference">
            <h3 data-type="title">Endnotes</h3>
            <div data-type="note" id="note1">
              <a href="#note1">
                <span>1</span>
              </a>
              <span>Victoria Knowles, “What’s the Difference Between CSR and Sustainability?”</span>
            </div>
          </section>
        </div>
        <div data-type="page" id="page2">
          <h1 data-type='document-title'>What Is Sociology?</h1>
          <p>Some text
            <a href="#something2" data-type="cite" id="some-id2">
              <div data-type="note" class="delete-me">
                <!-- no-selfclose -->
              </div>
            </a>
          </p>
          <section data-depth="1" id="2" class="reference">
            <h3 data-type="title">Endnotes</h3>
            <div data-type="note" id="note2">
              <a href="#note2">
                <span>2</span>
              </a>
              <span>Abercrombie, Nicholas, Stephen Hill, and Bryan S. Turner. 2000. The Penguin Dictionary of Sociology. London: Penguin.</span>
            </div>
          </section>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.new.bake(chapter: chapter, metadata_source: metadata_element)
    expect(chapter).to match_snapshot_auto
  end
end
