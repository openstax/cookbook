# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeNumberedNotes::V4 do
  let(:book_with_notes) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="page" id="page_1">
            <section class="wrapper">
              <div data-type="note" id="1" class="foo">
                <p>wrapped content #1</p>
              </div>
              <div data-type="note" id="2" class="foo">
                <p>wrapped content #2</p>
              </div>
            </section>
            <div data-type="note" id="3" class="foo">
              <p>not wrapped, not baked</p>
            </div>
          </div>
          <div data-type="page" id="page_2">
            <section class="wrapper">
              <div data-type="note" id="4" class="foo">
                <p>wrapped content #3</p>
              </div>
            </section>
          </div>
          <div data-type="page" id="page_4">
            <section class="wrapper">
              <div data-type="note" id="6" class="foo">
                <p>wrapped content with exercise</p>
                <div data-type="exercise">
                  <div data-type="problem">what is your quest?</div>
                </div>
              </div>
              <div data-type="note" id="7" class="foo">
                <p>wrapped content with injected question</p>
                <div data-type="injected-exercise">
                  <div data-type="exercise-question" data-id="26">
                    <div data-type="question-stem">a question stem</div>
                    <div data-type="question-solution">
                      some solution
                    </div>
                  </div>
                </div>
              </div>
            </section>
          </div>
        </div>
        <div data-type="chapter">
          <div data-type="page" id="page_3">
            <section class="wrapper">
              <div data-type="note" id="5" class="foo">
                <p>wrapped content, chapter 2</p>
              </div>
            </section>
          </div>
        </div>
      HTML
    )
  end

  before do
    stub_locales({
      'notes': {
        'foo': 'Bar'
      }
    })
  end

  it 'bakes only notes within the given container, numbered relative to scope' do
    described_class.new.bake(book: book_with_notes, classes: %w[foo], within: 'section.wrapper', scope: :chapter)
    expect(book_with_notes.body).to match_snapshot_auto
  end

  it 'returns the ids of the notes it baked, so callers can exclude them elsewhere' do
    result = described_class.new.bake(book: book_with_notes, classes: %w[foo], within: 'section.wrapper',
                                      scope: :chapter)
    expect(result).to contain_exactly('1', '2', '4', '5', '6', '7')
  end

  context 'when a matched note has no id' do
    let(:book_with_notes) do
      book_containing(html:
        <<~HTML
          <div data-type="chapter">
            <div data-type="page" id="page_1">
              <section class="wrapper">
                <div data-type="note" class="foo">
                  <p>wrapped content, no id</p>
                </div>
              </section>
            </div>
          </div>
        HTML
      )
    end

    it 'raises rather than silently returning an unusable id' do
      expect do
        described_class.new.bake(book: book_with_notes, classes: %w[foo], within: 'section.wrapper', scope: :chapter)
      end.to raise_error(/missing id on note/)
    end
  end
end
