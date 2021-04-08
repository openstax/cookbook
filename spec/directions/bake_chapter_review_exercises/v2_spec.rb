# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterReviewExercises::V2 do
  before do
    stub_locales({
      'eoc_exercises_title': 'Review Exercises',
      'eoc_chapter_review': 'Chapter Review',
      'eoc': {
        'CLASSNAME': 'foo'
      }
    })
  end

  let(:append_to) { new_element('<div class="os-eoc os-chapter-review-container"></div>') }

  let(:book_with_review_exercises) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="page">
            <div data-type="document-title">page title</div>
            <section id="sectionId1_fs-id-123456789" class="CLASSNAME">
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
          <div data-type="page">
            <div data-type="document-title">page 2 title</div>
            <section id="sectionId1_fs-id-123456789" class="CLASSNAME">
            </section>
          </div>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.new.bake(chapter: book_with_review_exercises.chapters.first, metadata_source: metadata_element, append_to: append_to, klass: 'CLASSNAME')
    expect(append_to).to match_normalized_html(
      <<~HTML
        <div class="os-eoc os-chapter-review-container">
            <div class="os-eoc os-CLASSNAME-container" data-type="composite-page" data-uuid-key=".CLASSNAME">
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
                <div class="os-CLASSNAME">
                  <div class="os-section-area">
                    <section id="sectionId1_fs-id-123456789" class="CLASSNAME">
                      <a href="#sectionId1_0">
                        <h3 data-type="document-title" id="sectionId1_0">
                          <span class="os-number">1.1</span>
                          <span class="os-divider"> </span>
                          <span class="os-text" data-type="" itemprop="">page title</span>
                        </h3>
                      </a>
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
                  <div class="os-section-area">
                    <section class="CLASSNAME" id="sectionId1_fs-id-123456789_copy_1">
                      <a href="#sectionId1_0">
                        <h3 data-type="document-title" id="sectionId1_0_copy_1">
                          <span class="os-number">1.2</span>
                          <span class="os-divider"> </span>
                          <span class="os-text" data-type="" itemprop="">page 2 title</span>
                        </h3>
                      </a>
                    </section>
                  </div>
                </div>
            </div>
          </div>
      HTML
    )
  end
end
