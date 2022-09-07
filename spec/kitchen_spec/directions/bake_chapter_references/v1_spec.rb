# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterReferences::V1 do

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
        <div data-type="page" class="introduction">
          <h1 data-type='document-title'>Introduction to Sociology</h1>
          <section data-depth="1" id="1" class="reference">
            <h3 data-type="title">References</h3>
            <p>Elias, Norbert. 1978. What Is Sociology? New York: Columbia University Press.</p>
          </section>
        </div>
        <div data-type="page">
          <h1 data-type='document-title'>What Is Sociology?</h1>
          <section data-depth="1" id="2" class="reference">
            <h3 data-type="title">References</h3>
            <p>Abercrombie, Nicholas, Stephen Hill, and Bryan S. Turner. 2000. The Penguin Dictionary of Sociology. London: Penguin.</p>
          </section>
        </div>
        <div data-type="page">
        <h1 data-type='document-title'>The History of Sociology</h1>
          <section data-depth="1" id="3" class="reference">
            <h3 data-type="title">References</h3>
            <p>Kierns, N. (2010). Ashley’s Alliance, unpublished presentation. Ohio State University.</p>
          </section>
        </div>
      HTML
    )
  end

  let(:chapter_with_module_with_titles_children) do
    chapter_element(
      <<~HTML
        <div data-type="page" class="introduction">
          <h1 data-type='document-title'>Introduction to Sociology</h1>
          <section data-depth="1" id="1" class="reference">
            <h3 data-type="title">References</h3>
            <p>Elias, Norbert. 1978. What Is Sociology? New York: Columbia University Press.</p>
          </section>
        </div>
        <div data-type="page">
          <h1 data-type='document-title'><em data-effect="italics">Italics</em> & not italics with <sub>subscript</sub> and <sup>superscript</sup> text What Is Sociology?</h1>
          <section data-depth="1" id="2" class="reference">
            <h3 data-type="title">References</h3>
            <p>Abercrombie, Nicholas, Stephen Hill, and Bryan S. Turner. 2000. The Penguin Dictionary of Sociology. London: Penguin.</p>
          </section>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.new.bake(chapter: chapter, metadata_source: metadata_element)
    expect(chapter).to match_snapshot_auto
  end

  context 'when there are module titles children present' do
    it 'keeps the module titles children while creating section title' do
      described_class.new.bake(chapter: chapter_with_module_with_titles_children, metadata_source: metadata_element)
      expect(chapter_with_module_with_titles_children).to match_snapshot_auto
    end
  end
end
