# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterSectionExercises::V1 do
  let(:book_with_section_exercises) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="page">
            <section id="sectionId1" class="section-exercises">
              <h3 data-type="title">A title</h3>
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
            <section id="sectionId2" class="section-exercises">
              <div data-type="exercise" id="exercise_id2">
                <div data-type="problem" id="problem_id2">
                  <p>exercise content 2</p>
                </div>
                <div data-type="solution" id="solution_id2">
                  <p>Solution content</p>
                </div>
              </div>
            </section>
          </div>
        </div>
      HTML
    )
  end

  let(:extra_title) { '<h3 data-type="title">A title</h3>' }

  let(:expected_result) do
    <<~HTML
      <div data-type="chapter">
        <div data-type="page">
          <div class="os-eos os-section-exercises-container" data-uuid-key=".section-exercises">
            <h3 data-type="document-title">
              <span class="os-text">Section 1.1 Exercises</span>
            </h3>
            <section id="sectionId1" class="section-exercises">
              #{extra_title}
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
          <div class="os-eos os-section-exercises-container" data-uuid-key=".section-exercises">
            <h3 data-type="document-title">
              <span class="os-text">Section 1.2 Exercises</span>
            </h3>
            <section id="sectionId2" class="section-exercises">
              <div data-type="exercise" id="exercise_id2">
                <div data-type="problem" id="problem_id2">
                  <p>exercise content 2</p>
                </div>
                <div data-type="solution" id="solution_id2">
                  <p>Solution content</p>
                </div>
              </div>
            </section>
          </div>
        </div>
      </div>
    HTML
  end

  context 'without deleting title' do
    it 'bakes, keeps in the title & create new one' do
      described_class.new.bake(chapter: book_with_section_exercises.chapters.first, options: { trash_title: false, create_title: true, numbering_options: {} })
      expect(book_with_section_exercises.chapters.first).to match_snapshot_auto
    end
  end

  context 'with title deleted' do
    it 'bakes & removes the title' do
      described_class.new.bake(chapter: book_with_section_exercises.chapters.first, options: { trash_title: true, create_title: false, numbering_options: {} })
      expect(book_with_section_exercises.chapters.first).to match_snapshot_auto
    end
  end

  context 'with title deleted and created new one' do
    let(:extra_title) { '' }

    it 'bakes, removes the title & create new one' do
      described_class.new.bake(chapter: book_with_section_exercises.chapters.first, options: { trash_title: true, create_title: true, numbering_options: {} })
      expect(book_with_section_exercises.chapters.first).to match_snapshot_auto
    end
  end
end
