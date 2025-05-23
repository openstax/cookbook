# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeNumberedNotes::V3 do
  let(:book_with_notes) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter"><div data-type="page" id="page_1">
          <div data-type="example">
            <span class="os-number">1.1</span>
          </div>
          <div data-type="note" id="123" class="foo">
            <p>content 1.1</p>
          </div>
          <div data-type="example">
            <span class="os-number">1.2</span>
          </div>
          <div data-type="example">
            <span class="os-number">1.3</span>
          </div>

          <div data-type="note" id="111" class="hello">
            <p>content 1.3</p>
          </div>
          <div data-type="example">
            <span class="os-number">1.4</span>
            <figure>
              <span class="os-title">Figure</span>
              <span class="os-number">1.1</span>
            </figure>
          </div>

          <div data-type="note" id="222" class="hello">
            <p>content 1.4</p>
          </div>
        </div></div>
        <div data-type="chapter"><div data-type="page" id="page_2">
          <div data-type="note" id="456" class="foo">
            <p>content 2.1</p>
          </div>
          <div data-type="note" id="789" class="foo">
            <p>content 2.2</p>
            <div data-type="exercise">
              <div data-type="problem">what is your quest?</div>
            </div>
          </div>
          <div data-type="example">
            <span class="os-number">2.2</span>
          </div>
          <div data-type="note" id="333" class="hello">
            <p>content 2.1</p>
            <div data-type="exercise" id="abcde">
              <div data-type="problem" id="unchanged">what is your favorite color?</div>
              <div data-type="solution" id="xyz">
                <p>Shh, it's a secret</p>
              </div>
            </div>
          </div>
          <div data-type="example">
            <span class="os-number">2.3</span>
          </div>
          <div data-type="note" id="000" class=":/">
            <p>don't bake me</p>
          </div>
          <div data-type="note" id="note_id15" class="theorem" use-subtitle="true">
            <div data-type="title" id="title_id15">Two Important Limits</div>
            <p> some content </p>
          </div>
          <div data-type="example">
            <span class="os-number">2.4</span>
          </div>
          <div data-type="note" id="4" class="foo">
            <p>A title 4</p>
            <div data-type="exercise" id="123">
              <div data-type="problem" id="456">Problem content</div>
              <div data-type="solution" id="xyz">
                <p>remove me</p>
              </div>
            </div>
            <div data-type="exercise" id="2_123">
              <div data-type="problem" id="2_456">a second exercise</div>
              <div data-type="solution" id="2_xyz">
                <p>get GONE</p>
              </div>
            </div>
          </div>
          <div data-type="example">
            <span class="os-number">2.5</span>
          </div>
          <table>
            <th>Some Relevant Data</th>
          </table>
          <div data-type="note" id="123" class="foo">
            <p>note with injected exercise</p>
            <div data-type="injected-exercise">
              <div data-type="exercise-question" data-id="17">
                <div data-type="question-stem">a question stem</div>
                <div data-type="question-solution">
                  some solution
                </div>
              </div>
            </div>
          </div>
          <div data-type="note" id="123" class="foo">
            <p>note with solution to be suppressed</p>
            <div data-type="solution">
              <p>Some Solution</p>
            </div>
          </div>
        </div></div>
      HTML
    )
  end

  let(:note_after_example) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="page">
            <div data-type="example">
              <span class="os-number">1.1</span>
            </div>
            <div data-type="note" id="123" class="foo">
              <p>content 1.1</p>
            </div>
            </div>
          </div>
        </div>
      HTML
    )
  end

  before do
    stub_locales({
      'notes': {
        'foo': 'Bar',
        'hello': 'Hello World',
        'theorem': 'Theorem'
      }
    })
  end

  it 'bakes' do
    described_class.new.bake(
      book: book_with_notes,
      classes: %w[foo hello theorem],
      options: { suppress_solution: true }
    )
    expect(book_with_notes.body).to match_snapshot_auto
  end

  it 'stores link text' do
    pantry = note_after_example.pantry(name: :link_text)
    expect(pantry).to receive(:store).with('Bar 1.1', { label: '123' })
    described_class.new.bake(book: note_after_example, classes: %w[foo], options: { suppress_solution: true })
  end
end
