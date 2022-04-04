# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::MoveExercisesToEOC::V3 do
  before do
    stub_locales({
      'eoc_composite_metadata_title': 'Review Exercises',
      'eoc_chapter_review': 'Chapter Review',
      'eoc': {
        'CLASSNAME': 'foo'
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
            <div data-type="document-title" id="page1TitleId">page title</div>
            <section id="sectionId1" class="CLASSNAME">
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
            <div data-type="document-title" id="page2TitleId">page 2 title</div>
            <section id="sectionId2" class="CLASSNAME">
            </section>
          </div>
        </div>
      HTML
    )
  end

  context 'when append_to is not null' do
    it 'works' do
      described_class.new.bake(chapter: book_with_review_exercises.chapters.first, metadata_source: metadata_element, append_to: append_to, klass: 'CLASSNAME')
      expect(append_to).to match_snapshot_auto
    end
  end

  context 'when append_to is null' do
    it 'works' do
      described_class.new.bake(chapter: book_with_review_exercises.chapters.first, metadata_source: metadata_element, klass: 'CLASSNAME')
      expect(book_with_review_exercises.chapters.first).to match_snapshot_auto
    end
  end
end
