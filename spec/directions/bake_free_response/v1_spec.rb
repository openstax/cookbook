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

  it 'works' do
    described_class.new.bake(chapter: chapter, metadata_source: metadata_element, append_to: nil)
    expect(chapter).to match_normalized_html(
      <<~HTML
        <div data-type="chapter">
          <div data-type="page">
            <h1 data-type="document-title">Stuff and Things</h1>
          </div>
          <div class="os-eoc os-free-response-container" data-type="composite-page" data-uuid-key=".free-response">
            <h2 data-type="document-title">
              <span class="os-text">Homework</span>
            </h2>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Homework</h1>
              <div class="authors" id="authors_copy_1">Authors</div>
              <div class="publishers" id="publishers_copy_1">Publishers</div>
              <div class="print-style" id="print-style_copy_1">Print Style</div>
              <div class="permissions" id="permissions_copy_1">Permissions</div>
              <div data-type="subject" id="subject_copy_1">Subject</div>
            </div>
            <section class="free-response" data-depth="1" id="0">
              <a href="#">
                <h3 data-type="document-title" id="">
                  <span class="os-number">1.1</span>
                  <span class="os-divider"> </span>
                  <span class="os-text" data-type="" itemprop="">Stuff and Things</span>
                </h3>
              </a>
            </section>
          </div>
        </div>
      HTML
    )
  end

end
