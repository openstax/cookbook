# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeNumberedNotes::V3 do
  let(:book_with_notes) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="exercise">
            <span class="os-number">1.1</span>
          </div>
          <div data-type="note" id="123" class="foo">
            <p>content 1.1</p>
          </div>
          <div data-type="exercise">
            <span class="os-number">1.2</span>
          </div>
          <div data-type="exercise">
            <span class="os-number">1.3</span>
          </div>

          <div data-type="note" id="111" class="hello">
            <p>content 1.3</p>
          </div>
          <div data-type="exercise">
            <span class="os-number">1.4</span>
            <figure>
              <span class="os-title">Figure</span>
              <span class="os-number">1.1</span>
            </figure>
          </div>
          <div data-type="note" id="222" class="hello">
            <p>content 1.4</p>
          </div>
        </div>
        <div data-type="chapter">
          <div data-type="note" id="456" class="foo">
            <p>content 2.1</p>
          </div>
          <div data-type="note" id="789" class="foo">
            <p>content 2.2</p>
            <div data-type="exercise">
              <div data-type="problem">what is your quest?</div>
            </div>
          </div>
          <div data-type="exercise">
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
          <div data-type="note" id="123" class="foo">
            <p>note with injected exercise</p>
            <div data-type="injected-exercise">
              <div data-type="exercise-question">
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
    described_class.new.bake(
      book: book_with_notes,
      classes: %w[foo hello theorem],
      suppress_solution: true
    )
    expect(book_with_notes.body).to match_normalized_html(
      <<~HTML
        <body>
          <div data-type="chapter">
            <div data-type="exercise">
              <span class="os-number">1.1</span>
            </div>
            <div class="foo" data-type="note" id="123">
              <h3 class="os-title">
                <span class="os-title-label">Bar</span>
                <span class="os-number">1.1</span>
              </h3>
              <div class="os-note-body">
                <p>content 1.1</p>
              </div>
            </div>
            <div data-type="exercise">
              <span class="os-number">1.2</span>
            </div>
            <div data-type="exercise">
              <span class="os-number">1.3</span>
            </div>
            <div class="hello" data-type="note" id="111">
              <h3 class="os-title">
                <span class="os-title-label">Hello World</span>
                <span class="os-number">1.3</span>
              </h3>
              <div class="os-note-body">
                <p>content 1.3</p>
              </div>
            </div>
            <div data-type="exercise">
              <span class="os-number">1.4</span>
              <figure>
                <span class="os-title">Figure</span>
                <span class="os-number">1.1</span>
              </figure>
            </div>
            <div class="hello" data-type="note" id="222">
              <h3 class="os-title">
                <span class="os-title-label">Hello World</span>
                <span class="os-number">1.4</span>
              </h3>
              <div class="os-note-body">
                <p>content 1.4</p>
              </div>
            </div>
          </div>
          <div data-type="chapter">
            <div class="foo" data-type="note" id="456">
              <h3 class="os-title">
                <span class="os-title-label">Bar</span>
                <span class="os-number"></span>
              </h3>
              <div class="os-note-body">
                <p>content 2.1</p>
              </div>
            </div>
            <div class="foo" data-type="note" id="789">
              <h3 class="os-title">
                <span class="os-title-label">Bar</span>
                <span class="os-number"></span>
              </h3>
              <div class="os-note-body">
                <p>content 2.2</p>
                <div class="unnumbered" data-type="exercise">
                  <div data-type="problem">
                    <div class="os-problem-container">what is your quest?</div>
                  </div>
                </div>
              </div>
            </div>
            <div data-type="exercise">
              <span class="os-number">2.2</span>
            </div>
            <div class="hello" data-type="note" id="333">
              <h3 class="os-title">
                <span class="os-title-label">Hello World</span>
                <span class="os-number">2.2</span>
              </h3>
              <div class="os-note-body">
                <p>content 2.1</p>
                <div class="unnumbered os-hasSolution" data-type="exercise" id="abcde">
                  <div data-type="problem" id="unchanged">
                    <div class="os-problem-container">what is your favorite color?</div>
                  </div>
                </div>
              </div>
            </div>
            <div data-type="note" id="000" class=":/">
              <p>don't bake me</p>
            </div>
            <div class="theorem" data-type="note" id="note_id15" use-subtitle="true">
              <h3 class="os-title">
                <span class="os-title-label">Theorem</span>
                <span class="os-number"></span>
              </h3>
              <div class="os-note-body">
                <p> some content </p>
              </div>
            </div>
            <div class="foo" data-type="note" id="4">
              <h3 class="os-title">
                <span class="os-title-label">Bar</span>
                <span class="os-number"></span>
              </h3>
              <div class="os-note-body">
                <p>A title 4</p>
                <div class="unnumbered os-hasSolution" data-type="exercise" id="123">
                  <div data-type="problem" id="456">
                    <div class="os-problem-container">Problem content</div>
                  </div>
                </div>
                <div class="unnumbered os-hasSolution" data-type="exercise" id="2_123">
                  <div data-type="problem" id="2_456">
                    <div class="os-problem-container">a second exercise</div>
                  </div>
                </div>
              </div>
            </div>
            <div class="foo" data-type="note" id="123">
              <h3 class="os-title">
                <span class="os-title-label">Bar</span>
                <span class="os-number"></span>
              </h3>
              <div class="os-note-body">
                <p>note with injected exercise</p>
                <div data-type="injected-exercise">
                  <div class="unnumbered os-hasSolution" data-type="exercise-question">
                    <div class="os-problem-container">
                      <div data-type="question-stem">a question stem</div>
                    </div>
                    <div data-type="question-solution" id="-solution">
                      <a class="os-number" href="#"></a>
                      <span class="os-divider">. </span>
                      <div class="os-solution-container">
                  some solution
                </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </body>
      HTML
    )
  end
end
