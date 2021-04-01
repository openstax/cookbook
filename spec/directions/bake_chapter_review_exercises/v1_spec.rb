# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterReviewExercises::V1 do
  before do
    stub_locales({
      'eoc_exercises_title': 'Review Exercises',
      'eoc_chapter_review': 'Chapter Review'
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

  let(:metadata) do
    <<~HTML
      <div data-type="metadata" style="display: none;">
        <h1 data-type="document-title" itemprop="name">A Title</h1>
        <div class="authors">
          <span id="author-1#" ><a>OpenStaxCollege</a></span>
        </div>
        <div class="publishers">
          <span id="publisher-1#"><a>OpenStaxCollege</a></span>
        </div>
        <div class="print-style">
          <span data-type="print-style">ccap-book</span>
        </div>
        <div class="permissions">
          <p class="copyright">
            <span id="copyright-holder-1#"><a>OSCRiceUniversity</a></span>
          </p>
          <p class="license">
            <a>CC BY</a>
          </p>
        </div>
        <div itemprop="about" data-type="subject">Book Title</div>
      </div>
    HTML
  end

  it 'works' do
    described_class.new.bake(chapter: book_with_review_exercises.chapters.first, metadata_source: metadata, append_to: append_to)
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
                  <span class="os-text">Review Exercises</span>
                </h3>
                <div data-type="metadata" style="display: none;">
                  <h1 data-type="document-title" itemprop="name">Review Exercises</h1>
                  <div data-type="metadata" style="display: none;">
                      <h1 data-type="document-title" itemprop="name">A Title</h1>
                      <div class="authors">
                        <span id="author-1#"><a>OpenStaxCollege</a></span>
                      </div>
                      <div class="publishers">
                        <span id="publisher-1#"><a>OpenStaxCollege</a></span>
                      </div>
                      <div class="print-style">
                        <span data-type="print-style">ccap-book</span>
                      </div>
                      <div class="permissions">
                        <p class="copyright">
                            <span id="copyright-holder-1#"><a>OSCRiceUniversity</a></span>
                        </p>
                        <p class="license">
                            <a>CC BY</a>
                        </p>
                      </div>
                      <div itemprop="about" data-type="subject">Book Title</div>
                  </div>
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
