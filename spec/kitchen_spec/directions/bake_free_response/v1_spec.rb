# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeFreeResponse::V1 do

  before do
    stub_locales({
      'eoc_free_response': 'Homework'
    })
  end

  let(:chapter) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="page">
            <h1 data-type='document-title'>Stuff and Things</h1>
            <section data-depth="1" id="0" class="free-response">
              <h3 data-type="title">HOMEWORK</h3>
            </section>
          </div>
        </div>
      HTML
    ).chapters.first
  end

  let(:chapter_with_module_titles_children) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="page">
            <h1 data-type='document-title'><em data-effect="italics">Italics</em> & not italics with <sub>subscript</sub> and <sup>superscript</sup> text Stuff and Things</h1>
            <section data-depth="1" id="0" class="free-response">
              <h3 data-type="title">HOMEWORK</h3>
            </section>
          </div>
        </div>
      HTML
    ).chapters.first
  end

  it 'works' do
    described_class.new.bake(chapter: chapter, metadata_source: metadata_element, append_to: nil)
    expect(chapter).to match_snapshot_auto
  end

  context 'when chapter contains module with titles children' do
    it 'keeps the module titles children in while creating ection title' do
      described_class.new.bake(chapter: chapter_with_module_titles_children, metadata_source: metadata_element, append_to: nil)
      expect(chapter_with_module_titles_children).to match_snapshot_auto
    end
  end

end
