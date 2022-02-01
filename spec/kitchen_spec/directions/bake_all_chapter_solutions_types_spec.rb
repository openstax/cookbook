# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeAllChapterSolutionsTypes do
  before do
    stub_locales({
      'eoc': {
        'solutions': 'Solutions'
      }
    })
  end

  let(:chapter) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="page">
            <h1 data-type='document-title'>Stuff and Things</h1>
            <section data-depth="1" id="0" class="free-response">
              <h3 data-type="title">HOMEWORK</h3>
              <div data-type="exercise">
                <div data-type="problem">How much wood does a wood chuck chuck?</div>
                <div data-type="solution" id='1'>
                  <p>Not much here because bakeNumberedNotes does that for us </p>
                </div>
              </div>
              <div data-type="injected-exercise" data-injected-from-nickname="multiFR" data-injected-from-version="2" data-injected-from-url="url" data-tags="type:practice all" data-is-vocab="False">
                <div data-type="exercise-stimulus">Exercise stimulus</div>
                <div data-type="exercise-question" id="id1" data-is-answer-order-important="False" data-formats="free-response" data-id="1">
                  <div data-type="question-stem">Question 1</div>
                  <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed">
                    solution 1
                  </div>
                </div>
              </div>
            </section>
            <section data-depth="1" id="0" class="practice">
              <h3 data-type="title">PRACTICE</h3>
              <div data-type="exercise">
                <div data-type="problem">What is the airspeed velocity of an unladen swallow?</div>
                <div data-type="solution" id='3'>
                  <p>Something that Numbered Notes will handle</p>
                </div>
              </div>
              <div data-injected-from-nickname="OXTest-OE-02" data-injected-from-url="https://exercises.openstax.org/api/exercises?q=nickname:OXTest-OE-02" data-injected-from-version="1" data-is-vocab="false" data-tags="all type:practice" data-type="injected-exercise">
                <div data-formats="free-response" data-id="181025" data-is-answer-order-important="false" data-type="exercise-question">
                  <div data-type="question-stimulus">I am a question stimulus! Here is some math <span data-math="22\,\text{N}">. And some <b>HTML</b> <i>HTML</i>.</span></div>
                  <div data-type="question-stem">Here is some other testing testing question stem for open ended. What is the meaning of life?</div>
                  <div data-solution-source="collaborator" data-solution-type="detailed" data-type="question-solution">
                    The meaning of life is what you want in your heart to be.
                  </div>
                </div>
              </div>
            </section>
          </div>
        </div>
      HTML
    ).chapters.first
  end

  it 'works' do
    described_class.v1(chapter: chapter,
                       within: chapter.search('section.free-response, section.practice'),
                       metadata_source: metadata_element,
                       uuid_prefix: '')
    expect(chapter).to match_normalized_html(
      <<~HTML
        <div data-type="chapter">
          <div data-type="page">
            <h1 data-type="document-title">Stuff and Things</h1>
            <section class="free-response" data-depth="1" id="0">
              <h3 data-type="title">HOMEWORK</h3>
              <div data-type="exercise">
                <div data-type="problem">How much wood does a wood chuck chuck?</div>
              </div>
              <div data-type="injected-exercise" data-injected-from-nickname="multiFR" data-injected-from-version="2" data-injected-from-url="url" data-tags="type:practice all" data-is-vocab="False">
                <div data-type="exercise-stimulus">Exercise stimulus</div>
                <div data-type="exercise-question" id="id1" data-is-answer-order-important="False" data-formats="free-response" data-id="1">
                  <div data-type="question-stem">Question 1</div>
                </div>
              </div>
            </section>
            <section class="practice" data-depth="1" id="0">
              <h3 data-type="title">PRACTICE</h3>
              <div data-type="exercise">
                <div data-type="problem">What is the airspeed velocity of an unladen swallow?</div>
              </div>
              <div data-injected-from-nickname="OXTest-OE-02" data-injected-from-url="https://exercises.openstax.org/api/exercises?q=nickname:OXTest-OE-02" data-injected-from-version="1" data-is-vocab="false" data-tags="all type:practice" data-type="injected-exercise">
                <div data-formats="free-response" data-id="181025" data-is-answer-order-important="false" data-type="exercise-question">
                  <div data-type="question-stimulus">I am a question stimulus! Here is some math <span data-math="22\,\text{N}">. And some <b>HTML</b> <i>HTML</i>.</span></div>
                  <div data-type="question-stem">Here is some other testing testing question stem for open ended. What is the meaning of life?</div>
                </div>
              </div>
            </section>
          </div>
          <div class="os-eoc os-solutions-container" data-type="composite-page" data-uuid-key="solutions">
            <h2 data-type="document-title">
              <span class="os-text">Solutions</span>
            </h2>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Solutions</h1>
              <span data-type="revised" id="revised_copy_1">Revised</span>
              <span data-type="slug" id="slug_copy_1">Slug</span>
              <div class="authors" id="authors_copy_1">Authors</div>
              <div class="publishers" id="publishers_copy_1">Publishers</div>
              <div class="print-style" id="print-style_copy_1">Print Style</div>
              <div class="permissions" id="permissions_copy_1">Permissions</div>
              <div data-type="subject" id="subject_copy_1">Subject</div>
            </div>
            <div data-type="solution" id="1">
              <p>Not much here because bakeNumberedNotes does that for us </p>
            </div>
            <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed">
                    solution 1
                  </div>
            <div data-type="solution" id="3">
              <p>Something that Numbered Notes will handle</p>
            </div>
            <div data-solution-source="collaborator" data-solution-type="detailed" data-type="question-solution">
                    The meaning of life is what you want in your heart to be.
                  </div>
          </div>
        </div>
      HTML
    )
  end
end
