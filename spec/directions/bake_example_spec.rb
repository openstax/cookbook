# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeExample do
  let(:exercise) { '' }
  let(:table) { '' }
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
              #{table}
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
          <div data-type="commentary" id="commentary_id">
            <div data-type="title" id="title_id">Analysis</div>
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
                <div data-type="commentary" id="commentary_id">
                  <h4 data-type="commentary-title" id="title_id">
                    <span class="os-title-label">Analysis</span>
                  </h4>
                </div>
              </div>
            </div>
          </div>
        HTML
      )
    end
  end

  context 'when there is a table' do
    let(:table) do
      <<~HTML
        <div class="os-table">
          <table class="some-class" id="tId">
            <thead>
              <tr>
                <th>A title</th>
              </tr>
              <tr>
                <th>Another heading cell</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>One lonely cell</td>
              </tr>
            </tbody>
          </table>
          <div class="os-caption-container">
            <span class="os-title-label">Table </span>
            <span class="os-number">S</span>
            <span class="os-divider"> </span>
            <span class="os-caption">
              <span data-type="title">Secret Title</span>
            </span>
          </div>
        </div>
      HTML
    end

    it 'doesn\'t affect the baked table' do
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
              #{table}
            </div>
          </div>
        HTML
      )
    end
  end

  context 'when there is more than one exercise with solutions' do
    let(:exercise) do
      <<~HTML
        <div data-type="exercise" id="exercise_id">
          <div data-type="problem" id="problem_id">
            <div data-type="title" id="title_id">Evaluating Functions</div>
            <p>example content</p>
          </div>
          <div data-type="solution" id="solution_id">
            <p>Solution One Content</p>
          </div>
          <div data-type="commentary" id="commentary_id">
            <div data-type="title" id="title_id">Analysis</div>
          </div>
        </div>
        <div data-type="exercise" id="exercise_id">
          <div data-type="problem" id="problem_id">
            <div data-type="title" id="title_id">Evaluating Functions</div>
            <p>example content</p>
          </div>
          <div data-type="solution" id="solution_id">
            <p>Solution Two Content</p>
          </div>
        </div>
      HTML
    end

    it 'numbers the solutions correctly when numbered_solutions true' do
      described_class.v1(
        example: example,
        number: 4,
        title_tag: 'title-tag-name',
        numbered_solutions: true
      )
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
                    <span class="os-number">1</span>
                  </h4>
                  <div class="os-solution-container">
                    <p>Solution One Content</p>
                  </div>
                </div>
                <div data-type="commentary" id="commentary_id">
                  <h4 data-type="commentary-title" id="title_id">
                    <span class="os-title-label">Analysis</span>
                  </h4>
                </div>
              </div>
              <div class="unnumbered" data-type="exercise" id="exercise_id">
                <div data-type="problem" id="problem_id">
                  <div class="os-problem-container">
                    <h4 data-type="title" id="title_id">Evaluating Functions</h4>
                    <p>example content</p>
                  </div>
                </div>
                <div data-type="solution" id="solution_id">
                  <h4 data-type="solution-title">
                    <span class="os-title-label">Solution </span>
                    <span class="os-number">2</span>
                  </h4>
                  <div class="os-solution-container">
                    <p>Solution Two Content</p>
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
      example.pantry(name: :link_text).get(example.id)
    }.from(nil)
  end
end
