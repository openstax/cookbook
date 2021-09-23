# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::MoveSolutionsToAnswerKey::V1 do
  before do
    stub_locales({
      'chapter': 'Chapter',
      'eoc': {
        'review-conceptual-questions': 'Conceptual Questions',
        'review-problems': 'Problems',
        'review-additional-problems': 'Additional Problems',
        'review-challenge': 'Challenge'
      },
      'notes': {
        'check-understanding': 'Check Understanding'
      }
    })
  end

  let(:book1) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <h1 data-type="document-title">Title for Ch1</h1>
          <div data-type="page">
            <div class="check-understanding" data-type="note">
              <div data-type="exercise">
                <div data-type="problem">problem 1</div>
                <div data-type="solution">solution 1</div>
              </div>
              <div data-type="exercise">
                <div data-type="problem">another one</div>
                <div data-type="solution">another solution</div>
              </div>
            </div>
            <div class="check-understanding" data-type="note">
              <div data-type="exercise">
                <div data-type="problem">no solution</div>
              </div>
            </div>
            <section class="review-conceptual-questions">
              <div data-type="exercise">
                <div data-type="problem">Problem 1</div>
                <div data-type="solution">Solution 1</div>
              </div>
              <div data-type="exercise">
                <div data-type="problem">Problem 2</div>
              </div>
              <div data-type="exercise">
                <div data-type="problem">Problem 3</div>
                <div data-type="solution">Solution 3</div>
              </div>
            </section>
            <section class="review-problems">
              <div data-type="exercise">
                <div data-type="problem">Problem 1</div>
                <div data-type="solution">Solution 1</div>
              </div>
            </section>
          </div>
          <div data-type="page">
            <section class="review-conceptual-questions">
              <div data-type="exercise">
                <div data-type="problem">Problem 1</div>
                <div data-type="solution">Solution 1</div>
              </div>
            </section>
            <section class="review-challenge">
              <div data-type="exercise">
                <div data-type="problem">Problem 1</div>
                <div data-type="solution">Solution 1</div>
              </div>
            </section>
          </div>
        </div>
        <div data-type="chapter">
          <h1 data-type="document-title">Title for Ch2</h1>
          <div data-type="page">
            <section class="review-conceptual-questions">
              <div data-type="exercise">
                <div data-type="problem">Problem 1</div>
                <div data-type="solution">Solution 1</div>
              </div>
            </section>
            <section class="review-additional-problems">
              <div data-type="exercise">
                <div data-type="problem">Problem 1</div>
                <div data-type="solution">Solution 1</div>
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
        <div class="lol"></div>
      HTML
    )
  end

  it 'works' do
    book1.chapters.each do |chapter|
      described_class.new.bake(
        chapter: chapter,
        metadata_source: metadata_element,
        strategy: :uphysics,
        append_to: append_to
      )
    end

    expect(append_to).to match_normalized_html(
      <<~HTML
        <div class="lol">
          <div class="os-eob os-solutions-container" data-type="composite-page" data-uuid-key=".solutions1">
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
                <span class="os-title-label">Check Understanding</span>
              </h3>
              <div data-type="solution">solution 1</div>
              <div data-type="solution">another solution</div>
            </div>
            <div class="os-solution-area">
              <h3 data-type="title">
                <span class="os-title-label">Conceptual Questions</span>
              </h3>
              <div data-type="solution">Solution 1</div>
              <div data-type="solution">Solution 3</div>
              <div data-type="solution">Solution 1</div>
            </div>
            <div class="os-solution-area">
              <h3 data-type="title">
                <span class="os-title-label">Problems</span>
              </h3>
              <div data-type="solution">Solution 1</div>
            </div>
            <div class="os-solution-area">
              <h3 data-type="title">
                <span class="os-title-label">Challenge</span>
              </h3>
              <div data-type="solution">Solution 1</div>
            </div>
          </div>
          <div class="os-eob os-solutions-container" data-type="composite-page" data-uuid-key=".solutions2">
            <h2 data-type="document-title">
              <span class="os-text">Chapter 2</span>
            </h2>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Chapter 2</h1>
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
                <span class="os-title-label">Conceptual Questions</span>
              </h3>
              <div data-type="solution">Solution 1</div>
            </div>
            <div class="os-solution-area">
              <h3 data-type="title">
                <span class="os-title-label">Additional Problems</span>
              </h3>
              <div data-type="solution">Solution 1</div>
            </div>
          </div>
        </div>
      HTML
    )
  end

  it 'gets composite pages' do
    book1.chapters.each do |chapter|
      described_class.new.bake(
        chapter: chapter,
        metadata_source: metadata_element,
        strategy: :uphysics,
        append_to: append_to
      )
    end
    expect(append_to.composite_pages.count).to eq 2
  end
end
