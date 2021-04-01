# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeExample do
  let(:exercise) { '' }
  let(:example) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="page">
            <div data-type="document-title" id="auto_m68761_72010">Page 1 Title</div>
            <div data-type='example' id='example-test'>
              <span data-type="title">example title becomes h4</span>
              <p>content</p>
              #{exercise}
            </div>
          </div>
        </div>
      HTML
    ).chapters.pages.examples.first
  end

  it 'works' do
    described_class.v1(example: example, number: 4, title_tag: 'title-tag-name')
    expect(example).to match_normalized_html(
      <<~HTML
        <div data-type="example" id="example-test">
          <title-tag-name class="os-title">
            <span class="os-title-label">Example </span>
            <span class="os-number">4</span>
            <span class="os-divider"> </span>
          </title-tag-name>
          <div class="body">
            <h4 data-type="title">example title becomes h4</h4>
            <p>content</p>
          </div>
        </div>
      HTML
    )
  end

  context 'when there is an exercise' do
    let(:exercise) do
      <<~HTML
        <div data-type="exercise" id="exercise_id">
          <div data-type="problem" id="problem_id">
            <div data-type="title" id="title_id">Evaluating Functions</div>
            <p>example content</p>
          </div>
          <div data-type="solution" id="solution_id">
            <p>Solution content</p>
          </div>
        </div>
      HTML
    end

    it 'works' do
      described_class.v1(example: example, number: 4, title_tag: 'title-tag-name')
      expect(example).to match_normalized_html(
        <<~HTML
          <div data-type="example" id="example-test">
            <title-tag-name class="os-title">
              <span class="os-title-label">Example </span>
              <span class="os-number">4</span>
              <span class="os-divider"> </span>
            </title-tag-name>
            <div class="body">
              <h4 data-type="title">example title becomes h4</h4>
              <p>content</p>
              <div data-type="exercise" id="exercise_id" class="unnumbered">
                <div data-type="problem" id="problem_id">
                  <div class="os-problem-container">
                    <h4 data-type="title" id="title_id">Evaluating Functions</h4>
                    <p>example content</p>
                  </div>
                </div>
                <div data-type="solution" id="solution_id">
                  <h4 data-type="solution-title">
                    <span class="os-title-label">Solution </span>
                  </h4>
                  <div class="os-solution-container">
                    <p>Solution content</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        HTML
      )
    end
  end

  it 'stores info in the pantry' do
    expect { described_class.v1(example: example, number: 4, title_tag: 'title-tag-name') }.to change {
      example.document.pantry(name: :link_text).get(example.id)
    }.from(nil)
  end
end
