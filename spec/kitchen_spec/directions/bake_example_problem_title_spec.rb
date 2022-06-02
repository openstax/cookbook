# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeExampleProblemTitle do

  before do
    stub_locales({
      'problem': 'Problem'
    })
  end

  let(:example) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="page">
            <div data-type="document-title" id="auto_m68761_72010">Page 1 Title</div>
            <div data-type='example' id='example-test'>
              <div data-type="exercise" id="exercise_id">
                <div data-type="problem" id="problem_id">
                  <p>example content</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      HTML
    ).chapters.pages.examples.first
  end

  let(:baked_example) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="page">
            <div data-type="document-title" id="auto_m68761_72010">Page 1 Title</div>
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
                        <p>example content</p>
                      </div>
                    </div>
                    <div data-type="solution" id="solution_id">
                      <h4 data-type="solution-title">
                        <span class="os-title-label">Solution</span>
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
            </div>
          </div>
      HTML
    ).chapters.pages.examples.first
  end

  it 'works' do
    described_class.v1(example: example)
    expect(example).to match_snapshot_auto
  end

  context 'when exercise is baked' do
    it 'works' do
      described_class.v1(example: baked_example)
      expect(baked_example).to match_snapshot_auto
    end
  end

end
