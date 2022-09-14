# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::MoveExercisesToEOC::V2 do
  before do
    stub_locales({
      'eoc_composite_metadata_title': 'Review Exercises',
      'eoc_chapter_review': 'Chapter Review',
      'eoc': {
        'CLASSNAME': 'foo'
      }
    })
  end

  let(:append_to) { new_element('<div class="os-eoc os-chapter-review-container" data-type="composite-chapter"></div>') }

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

  let(:book_with_review_exercises_in_module_with_title_children) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="page">
            <div data-type="document-title" id="page1TitleId"><em data-effect="italics">Italics</em> & not italics with <sub>subscript</sub> and <sup>superscript</sup> text page title</div>
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

  context 'when exercises are in module with titles chilren' do
    it 'keeps the modules titles children while creating a section title' do
      described_class.new.bake(chapter: book_with_review_exercises_in_module_with_title_children.chapters.first, metadata_source: metadata_element, klass: 'CLASSNAME')
      expect(book_with_review_exercises_in_module_with_title_children.chapters.first).to match_snapshot_auto
    end
  end
end
