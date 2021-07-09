# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterSolutions::V1 do
  before do
    stub_locales({
      'eoc': {
        'solutions': 'Solutions'
      }
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
              <div data-type="exercise">
                <div data-type="problem">How much wood does a wood chuck chuck?</div>
                <div data-type="solution" id='1'>
                  <p>Not much here because bakeNumberedNotes does that for us </p>
                </div>
              </div>
            </section>
          </div>
        </div>
      HTML
    ).chapters.first
  end

  it 'works' do
    described_class.new.bake(chapter: chapter, metadata_source: metadata_element, uuid_prefix: '')
    expect(chapter).to match_normalized_html(
      <<~HTML
        <div data-type="chapter">
          <div data-type="page">
            <h1 data-type="document-title">Stuff and Things</h1>
            <section class="free-response" data-depth="1" id="0">
              <h3 data-type="title">HOMEWORK</h3>
              <div data-type="exercise">
                <div data-type="problem">How much wood does a wood chuck chuck?</div>
              </div>
            </section>
          </div>
          <div class="os-eoc os-solutions-container" data-type="composite-page" data-uuid-key="solutions">
            <h2 data-type="document-title">
              <span class="os-text">Solutions</span>
            </h2>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Solutions</h1>
              <div class="authors" id="authors_copy_1">Authors</div>
              <div class="publishers" id="publishers_copy_1">Publishers</div>
              <div class="print-style" id="print-style_copy_1">Print Style</div>
              <div class="permissions" id="permissions_copy_1">Permissions</div>
              <div data-type="subject" id="subject_copy_1">Subject</div>
            </div>
            <div data-type="solution" id="1">
              <p>Not much here because bakeNumberedNotes does that for us </p>
            </div>
          </div>
        </div>
      HTML
    )
  end

end
