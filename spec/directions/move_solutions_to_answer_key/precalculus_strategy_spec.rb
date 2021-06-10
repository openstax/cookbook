# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::MoveSolutionsToAnswerKey::V1 do
  before do
    stub_locales({
      'eoc': {
        'practice-test': 'Practice Test',
        'review-exercises': 'Review Exercises',
        'section-exercises': 'Section #.# Exercises'
      },
      'chapter': 'Chapter',
      'notes': {
        'try': 'Try It'
      }
    })
  end

  let(:book1) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="page">
            <h2 data-type="document-title" id="page1Id">Page title for try solutions in eob</h2>
            <div data-type="note" class="precalculus try">
              <div data-type="exercise">
                <div data-type="problem"/>
                <div data-type="solution">try solution 1</div>
              </div>
            </div>
            <section class="section-exercises">
              <div data-type="exercise">
                <div data-type="problem"/>
                <div data-type="solution">section 1.1 solution 1</div>
              </div>
            </section>
          </div>
          <div data-type="page">
            <section class="section-exercises">
              <div data-type="exercise">
                <div data-type="problem"/>
                <div data-type="solution">section 1.2 solution 1</div>
              </div>
            </section>
            <section class="review-exercises">
              <div data-type="exercise">
                <div data-type="problem"/>
                <div data-type="solution">review solution 1</div>
              </div>
            </section>
            <section class="practice-test">
              <div data-type="exercise">
                <div data-type="problem"/>
                <div data-type="solution">practice solution 1</div>
              </div>
            </section>
          </div>
        </div>
      HTML
    )
  end

  let(:append_to) do
    new_element(
      <<~HTML
        <div class="top-level"></div>
      HTML
    )
  end

  it 'works' do
    book1.chapters.each do |chapter|
      described_class.new.bake(
        chapter: chapter,
        metadata_source: metadata_element,
        strategy: :precalculus,
        append_to: append_to,
        solutions_plural: false
      )
    end

    expect(append_to).to match_normalized_html(
      <<~HTML
        <div class="top-level">
          <div class="os-eob os-solution-container" data-type="composite-page" data-uuid-key=".solution1">
            <h2 data-type="document-title">
              <span class="os-text">Chapter 1</span>
            </h2>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Chapter 1</h1>
              <div class="authors" id="authors_copy_1">Authors</div>
              <div class="publishers" id="publishers_copy_1">Publishers</div>
              <div class="print-style" id="print-style_copy_1">Print Style</div>
              <div class="permissions" id="permissions_copy_1">Permissions</div>
              <div data-type="subject" id="subject_copy_1">Subject</div>
            </div>
            <div class="os-module-reset-solution-area os-try-solution-area">
              <h3 data-type="title">
                <span class="os-title-label">Try It</span>
              </h3>
              <div class="os-solution-area">
                <div>
                  <h3 data-type="document-title" id="page1Id_copy_1">
                    <span class="os-number">1.1</span>
                    <span class="os-divider"> </span>
                    <span class="os-text" data-type="" itemprop="">Page title for try solutions in eob</span>
                  </h3>
                </div>
                <div data-type="solution">try solution 1</div>
              </div>
            </div>
            <div class="os-solution-area">
              <h3 data-type="title">
                <span class="os-title-label">Section #.# Exercises</span>
              </h3>
              <div data-type="solution">section 1.1 solution 1</div>
            </div>
            <div class="os-solution-area">
              <h3 data-type="title">
                <span class="os-title-label">Section #.# Exercises</span>
              </h3>
              <div data-type="solution">section 1.2 solution 1</div>
            </div>
            <div class="os-solution-area">
              <h3 data-type="title">
                <span class="os-title-label">Review Exercises</span>
              </h3>
              <div data-type="solution">review solution 1</div>
            </div>
            <div class="os-solution-area">
              <h3 data-type="title">
                <span class="os-title-label">Practice Test</span>
              </h3>
              <div data-type="solution">practice solution 1</div>
            </div>
          </div>
        </div>
      HTML
    )
  end

  it 'raises exception if given an unrecognized book' do
    expect {
      described_class.new.bake(chapter: '', metadata_source: metadata_element, strategy: :unrecognized_strategy, append_to: append_to)
    }.to raise_error('No such strategy')
  end
end
