# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeNumberedNotes do
  let(:book_with_notes) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter"><div data-type="page" id="page_1">
          <div data-type="note" id="123" class="foo">
            <p>content 1.1</p>
          </div>
          <div data-type="note" id="111" class="hello">
            <p>content 1.1</p>
          </div>
          <div data-type="note" id="222" class="hello">
            <p>content 1.2</p>
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
          <div data-type="note" id="333" class="hello">
            <p>content 2.1</p>
            <div data-type="exercise" id="abcde">
              <div data-type="problem" id="unchanged">what is your favorite color?</div>
              <div data-type="solution" id="xyz">
                <p>chartreuse</p>
              </div>
            </div>
          </div>
          <div data-type="note" id="000" class=":/">
            <p>don't bake me</p>
          </div>
          <div data-type="note" id="note_id15" class="theorem" use-subtitle="true">
            <div data-type="title" id="title_id15">Two Important Limits</div>
            <p> some content </p>
          </div>
          <div data-type="note" id="4" class="foo">
            <p>A title 4</p>
            <div data-type="exercise" id="123">
              <div data-type="problem" id="456">Problem content</div>
              <div data-type="solution" id="xyz">
                <p>solution content</p>
              </div>
              <div data-type="commentary" id="xyza">
                <p>remove me</p>
              </div>
            </div>
            <div data-type="exercise" id="2_123">
              <div data-type="problem" id="2_456">a <strong>second</strong> exercise</div>
              <div data-type="solution" id="2_xyz">
                <p>second solution content</p>
              </div>
            </div>
          </div>
          <div data-type="note" id="4" class="foo">
            <p>A title 4</p>
            <div data-type="injected-exercise">
              <div data-type="exercise-question" data-id="1">
                <div data-type="question-stem">a question stem</div>
                <div data-type="question-solution">
                  some solution
                </div>
              </div>
            </div>
          </div>
        </div></div>
        <div data-type="page" class="appendix" id="page_3">
          <div data-type="note" id="5" class="foo">
            <p>A title 5</p>
            <div data-type="injected-exercise">
              <div data-type="exercise-question" data-id="2">
                <div data-type="question-stem">a question stem</div>
                <div data-type="question-solution">
                  some solution
                </div>
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
    described_class.v1(book: book_with_notes, classes: %w[foo hello theorem])
    expect(book_with_notes.body).to match_snapshot_auto
  end

  context 'when book does not use grammatical cases' do
    it 'stores link text' do
      pantry = book_with_notes.pantry(name: :link_text)
      expect(pantry).to receive(:store).with('Two Important Limits', { label: 'note_id15' })
      described_class.v1(book: book_with_notes, classes: %w[foo hello theorem])
    end
  end

  context 'when book uses grammatical cases' do
    it 'stores link text' do
      with_locale(:pl) do
        stub_locales({
          'note': {
            'nominative': 'Ramka',
            'genitive': 'Ramki'
          }
        })

        pantry = book_with_notes.pantry(name: :nominative_link_text)
        expect(pantry).to receive(:store).with('Ramka Two Important Limits', { label: 'note_id15' })

        pantry = book_with_notes.pantry(name: :genitive_link_text)
        expect(pantry).to receive(:store).with('Ramki Two Important Limits', { label: 'note_id15' })
        described_class.v1(book: book_with_notes, classes: %w[foo hello theorem], options: { cases: true })
      end
    end
  end
end
