# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterReviewExercises::V1 do
  before do
    stub_locales({
      'eoc_exercises_title': 'Review Exercises',
      'eoc_chapter_review': 'Chapter Review',
      'eoc': {
        'review-exercises': 'foo'
      }
    })
  end

  let(:append_to) do
    new_element(
      <<~HTML
        <div class="os-eoc os-chapter-review-container" data-type="composite-chapter" data-uuid-key=".chapter-review">
          <h2 data-type="document-title" id="composite-chapter-1">
            <span class="os-text">#{I18n.t(:eoc_chapter_review)}</span>
          </h2>
          <div data-type="metadata" style="display: none;">
            <h1 data-type="document-title" itemprop="name">#{I18n.t(:eoc_chapter_review)}</h1>
            <div>metadata</div>
          </div>
        </div>
      HTML
    )
  end

  let(:book_with_review_exercises) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="page">
            <section id="sectionId1" class="review-exercises">
              <div data-type="exercise" id="exercise_id1">
                <div data-type="problem" id="problem_id1">
                  <p>exercise content 1</p>
                </div>
                <div data-type="solution" id="solution_id1">
                  <p>Solution content</p>
                </div>
              </div>
            </section>
          </div>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.new.bake(chapter: book_with_review_exercises.chapters.first, metadata_source: metadata_element, append_to: append_to, klass: 'review-exercises')
    expect(append_to).to match_normalized_html(
      <<~HTML
        <div class="os-eoc os-chapter-review-container" data-type="composite-chapter" data-uuid-key=".chapter-review">
          <h2 data-type="document-title" id="composite-chapter-1">
            <span class="os-text">Chapter Review</span>
          </h2>
          <div data-type="metadata" style="display: none;">
            <h1 data-type="document-title" itemprop="name">Chapter Review</h1>
            <div>metadata</div>
            </div>
            <div class="os-eoc os-review-exercises-container" data-type="composite-page" data-uuid-key=".review-exercises">
                <h3 data-type="document-title">
                  <span class="os-text">foo</span>
                </h3>
                <div data-type="metadata" style="display: none;">
                  <h1 data-type="document-title" itemprop="name">Review Exercises</h1>
                  <div class="authors" id="authors_copy_1">Authors</div>
                  <div class="publishers" id="publishers_copy_1">Publishers</div>
                  <div class="print-style" id="print-style_copy_1">Print Style</div>
                  <div class="permissions" id="permissions_copy_1">Permissions</div>
                  <div data-type="subject" id="subject_copy_1">Subject</div>
                </div>
                <section id="sectionId1" class="review-exercises">
                  <div data-type="exercise" id="exercise_id1">
                      <div data-type="problem" id="problem_id1">
                        <p>exercise content 1</p>
                      </div>
                      <div data-type="solution" id="solution_id1">
                        <p>Solution content</p>
                      </div>
                  </div>
                </section>
            </div>
          </div>
      HTML
    )
  end
end
