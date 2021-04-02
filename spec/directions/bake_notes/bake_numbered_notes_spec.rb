# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeNumberedNotes do
  let(:book_with_notes) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="note" id="123" class="foo">
            <p>content 1.1</p>
          </div>
          <div data-type="note" id="111" class="hello">
            <p>content 1.1</p>
          </div>
          <div data-type="note" id="222" class="hello">
            <p>content 1.2</p>
          </div>
        </div>
        <div data-type="chapter">
          <div data-type="note" id="456" class="foo">
            <p>content 2.1</p>
          </div>
          <div data-type="note" id="789" class="foo">
            <p>content 2.2</p>
          </div>
          <div data-type="note" id="333" class="hello">
            <p>content 2.1</p>
          </div>
          <div data-type="note" id="000" class=":/">
            <p>don't bake me</p>
          </div>
        </div>
      HTML
    )
  end

  before do
    stub_locales({
      'notes': {
        'foo': 'Bar',
        'hello': 'Hello World'
      }
    })
  end

  it 'bakes' do
    described_class.v1(book: book_with_notes, classes: %w[foo hello])
    expect(book_with_notes.body).to match_normalized_html(
      <<~HTML
        <body>
          <div data-type="chapter">
            <div class="foo" data-type="note" id="123">
              <div class="os-title">
                <span class="os-title-label">Bar</span>
                <span class="os-number">1.1</span>
                <span class="os-divider"> </span>
              </div>
              <div class="os-note-body">
                <p>content 1.1</p>
              </div>
            </div>
            <div class="hello" data-type="note" id="111">
              <div class="os-title">
                <span class="os-title-label">Hello World</span>
                <span class="os-number">1.1</span>
                <span class="os-divider"> </span>
              </div>
              <div class="os-note-body">
                <p>content 1.1</p>
              </div>
            </div>
            <div class="hello" data-type="note" id="222">
              <div class="os-title">
                <span class="os-title-label">Hello World</span>
                <span class="os-number">1.2</span>
                <span class="os-divider"> </span>
              </div>
              <div class="os-note-body">
                <p>content 1.2</p>
              </div>
            </div>
          </div>
          <div data-type="chapter">
            <div class="foo" data-type="note" id="456">
              <div class="os-title">
                <span class="os-title-label">Bar</span>
                <span class="os-number">2.1</span>
                <span class="os-divider"> </span>
              </div>
              <div class="os-note-body">
                <p>content 2.1</p>
              </div>
            </div>
            <div class="foo" data-type="note" id="789">
              <div class="os-title">
                <span class="os-title-label">Bar</span>
                <span class="os-number">2.2</span>
                <span class="os-divider"> </span>
              </div>
              <div class="os-note-body">
                <p>content 2.2</p>
              </div>
            </div>
            <div class="hello" data-type="note" id="333">
              <div class="os-title">
                <span class="os-title-label">Hello World</span>
                <span class="os-number">2.1</span>
                <span class="os-divider"> </span>
              </div>
              <div class="os-note-body">
                <p>content 2.1</p>
              </div>
            </div>
            <div data-type="note" id="000" class=":/">
              <p>don't bake me</p>
            </div>
          </div>
        </body>
      HTML
    )
  end
end
