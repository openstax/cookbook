# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::MoveExercisesToEOC::V1 do
  before do
    stub_locales({
      'eoc_composite_metadata_title': 'Exercises',
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
            <h2 data-type="document-title" id="first" itemprop="name">First Title</h2>
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

  context 'when append_to is not null' do
    it 'works' do
      described_class.new.bake(chapter: book_with_review_exercises.chapters.first, metadata_source: metadata_element, append_to: append_to, klass: 'review-exercises')
      expect(append_to).to match_snapshot_auto
    end
  end

  context 'when append_to is null' do
    it 'works' do
      described_class.new.bake(chapter: book_with_review_exercises.chapters.first, metadata_source: metadata_element, klass: 'review-exercises')
      expect(book_with_review_exercises.chapters.first).to match_snapshot_auto
    end
  end
end
