# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::MoveSolutionsToAnswerKey do
  before do
    stub_locales({
      'chapter': 'Chapter',
      'notes': {
        'your-turn': 'Your Turn '
      },
      'eoc': {
        'section-exercises': 'Section #.# Exercises',
        'chapter-review': 'Chapter Review',
        'chapter-test': 'Chapter Test'
      }
    })
  end

  let(:book1) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="page">
            <div data-type="note" class="your-turn">
              <div data-type="exercise">
                <div data-type="problem"/>
                <div data-type="solution">
                  <a class="os-number">1.1</a>
                  <span class="os-divider"> </span>
                  <div class="os-solution-container">
                    your turn solution 1
                  </div>
                </div>
              </div>
            </div>
            <div data-type="note" class="your-turn">
              <div data-type="exercise">
                <div data-type="problem"/>
                <div data-type="solution">
                  <a class="os-number">1.2</a>
                  <span class="os-divider"> </span>
                  <div class="os-solution-container">
                    your turn solution 2
                  </div>
                </div>
              </div>
            </div>
            <section class="section-exercises">
              <div data-type="injected-exercise">
                <div data-type="exercise-question">
                  <div data-type="question-solution">
                    <a class="os-number">1</a>
                    <span class="os-divider"> </span>
                    <div class="os-solution-container">
                      section exercises solution 1
                    </div>
                  </div>
                </div>
              </div>
            </section>
          </div>
          <div data-type="page">
            <div data-type="note" class="your-turn">
            </div>
            <div data-type="note" class="your-turn">
              <div data-type="exercise">
                <div data-type="problem"/>
                <div data-type="solution">
                  <a class="os-number">1.4</a>
                  <span class="os-divider"> </span>
                  <div class="os-solution-container">
                    your turn solution 4
                  </div>
                </div>
              </div>
            </div>
            <section class="section-exercises">
              <div data-type="injected-exercise">
                <div data-type="exercise-question">
                  <div data-type="question-solution">
                    section exercise solution 2
                  </div>
                </div>
              </div>
            </section>
            <section class="chapter-review">
              <div data-type="injected-exercise">
                <div data-type="exercise-question">
                  <div data-type="question-solution">
                    chapter review solution 1
                  </div>
                </div>
              </div>
            </section>
            <section class="chapter-test">
              <div data-type="injected-exercise">
                <div data-type="exercise-question">
                  <div data-type="question-solution">
                    chapter test solution 1
                  </div>
                </div>
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
      described_class.v1(
        chapter: chapter,
        metadata_source: metadata_element,
        strategy: :contemporary_math,
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
              <span data-type="revised" id="revised_copy_1">Revised</span>
              <span data-type="slug" id="slug_copy_1">Slug</span>
              <div class="authors" id="authors_copy_1">Authors</div>
              <div class="publishers" id="publishers_copy_1">Publishers</div>
              <div class="print-style" id="print-style_copy_1">Print Style</div>
              <div class="permissions" id="permissions_copy_1">Permissions</div>
              <div data-type="subject" id="subject_copy_1">Subject</div>
            </div>
            <div class="os-solution-area">
              <h3 data-type="title">
                <span class="os-title-label">Your Turn </span>
              </h3>
              <div data-type="solution">
                <a class="os-number">1</a>
                <span class="os-divider">. </span>
                <div class="os-solution-container">
                    your turn solution 1
                  </div>
              </div>
              <div data-type="solution">
                <a class="os-number">2</a>
                <span class="os-divider">. </span>
                <div class="os-solution-container">
                    your turn solution 2
                  </div>
              </div>
              <div data-type="solution">
                <a class="os-number">4</a>
                <span class="os-divider">. </span>
                <div class="os-solution-container">
                    your turn solution 4
                  </div>
              </div>
            </div>
            <div class="os-solution-area">
              <h3 data-type="title">
                <span class="os-title-label">Section #.# Exercises</span>
              </h3>
              <div data-type="question-solution">
                <a class="os-number">1</a>
                <span class="os-divider"> </span>
                <div class="os-solution-container">
                      section exercises solution 1
                    </div>
              </div>
            </div>
            <div class="os-solution-area">
              <h3 data-type="title">
                <span class="os-title-label">Section #.# Exercises</span>
              </h3>
              <div data-type="question-solution">
                    section exercise solution 2
                  </div>
            </div>
            <div class="os-solution-area">
              <h3 data-type="title">
                <span class="os-title-label">Chapter Review</span>
              </h3>
              <div data-type="question-solution">
                    chapter review solution 1
                  </div>
            </div>
            <div class="os-solution-area">
              <h3 data-type="title">
                <span class="os-title-label">Chapter Test</span>
              </h3>
              <div data-type="question-solution">
                    chapter test solution 1
                  </div>
            </div>
          </div>
        </div>
      HTML
    )
  end
end
