# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeExercisePrefixes::V1 do

  before do
    stub_locales({
      'sections_prefixed': {
        'exercise-set-a': 'EA',
        'exercise-set-b': 'EB',
        'problem-set-a': 'PA',
        'problem-set-b': 'PB',
        'thought-provokers': 'TP'
        }
      })
  end

  let(:eoc_sections_prefixed) do
    %w[exercise-set-a
       exercise-set-b
       problem-set-a
       problem-set-b
       thought-provokers]
  end

  let(:chapter_with_prefixed_exercises) do
    chapter_element(
      <<~HTML
        <div class="os-eoc os-exercise-set-a-container" data-type="composite-page" data-uuid-key=".exercise-set-a" id="composite-page-1">
          <section class="exercise-set-a">
            <div data-type="exercise" id="exercise_id">
              <div data-type="problem" id="problem_id">
                <span class="os-number">1.1</>
                <span class="os-divider">. </span>
                <div class="os-problem-container">
                  <p>example content</p>
                </div>
              </div>
            </div>
          </section>
        </div>
        <div class="os-eoc os-exercise-set-b-container" data-type="composite-page" data-uuid-key=".exercise-set-b" id="composite-page-2">
          <section class="exercise-set-b">
            <div data-type="exercise" id="exercise_id">
              <div data-type="problem" id="problem_id">
                <span class="os-number">1.1</>
                <span class="os-divider">. </span>
                <div class="os-problem-container">
                  <p>example content</p>
                </div>
              </div>
            </div>
          </section>
        </div>
        <div class="os-eoc os-problem-set-a-container" data-type="composite-page" data-uuid-key=".problem-set-a" id="composite-page-3">
          <section class="problem-set-a">
            <div data-type="exercise" id="exercise_id">
              <div data-type="problem" id="problem_id">
                <span class="os-number">1.1</>
                <span class="os-divider">. </span>
                <div class="os-problem-container">
                  <p>example content</p>
                </div>
              </div>
            </div>
          </section>
        </div>
        <div class="os-eoc os-problem-set-b-container" data-type="composite-page" data-uuid-key=".problem-set-b" id="composite-page-4">
          <section class="problem-set-b">
            <div data-type="exercise" id="exercise_id">
              <div data-type="problem" id="problem_id">
                <span class="os-number">1.1</>
                <span class="os-divider">. </span>
                <div class="os-problem-container">
                  <p>example content</p>
                </div>
              </div>
            </div>
          </section>
        </div>
        <div class="os-eoc os-thought-provokers-container" data-type="composite-page" data-uuid-key=".thought-provokers" id="composite-page-5">
          <section class="thought-provokers">
            <div data-type="exercise" id="exercise_id">
              <div data-type="problem" id="problem_id">
                <span class="os-number">1.1</>
                <span class="os-divider">. </span>
                <div class="os-problem-container">
                  <p>example content</p>
                </div>
              </div>
            </div>
          </section>
        </div>
      HTML
    )
  end

  let(:chapter_with_unprefixed_exercises) do
    chapter_element(
      <<~HTML
        <div class="os-eoc os-multiple-choice-container" data-type="composite-page" data-uuid-key=".multiple-choice" id="composite-page-1">
          <section class="multiple-choice">
            <div data-type="exercise" id="exercise_id" class="os-hasSolution">
              <div data-type="problem" id="problem_id">
                <a class="os-number" href="#exercise_id-solution">1.1</a>
                <span class="os-divider">. </span>
                <div class="os-problem-container">
                  <p>example content</p>
                </div>
              </div>
            </div>
          </section>
        </div>
        <div class="os-eoc os-questions-container" data-type="composite-page" data-uuid-key=".questions" id="composite-page-2">
          <section class="questions">
            <div data-type="exercise" id="exercise_id" class="os-hasSolution">
              <div data-type="problem" id="problem_id">
                <a class="os-number" href="#exercise_id-solution">1.1</a>
                <span class="os-divider">. </span>
                <div class="os-problem-container">
                  <p>example content</p>
                </div>
              </div>
            </div>
          </section>
        </div>
      HTML
    )
  end

  it 'adds prefixes to exercises which need it' do
    described_class.new.bake(chapter: chapter_with_prefixed_exercises, sections_prefixed: eoc_sections_prefixed)
    expect(chapter_with_prefixed_exercises).to match_normalized_html(
      <<~HTML
        <div data-type="chapter">
          <div class="os-eoc os-exercise-set-a-container" data-type="composite-page" data-uuid-key=".exercise-set-a" id="composite-page-1">
            <section class="exercise-set-a">
              <div data-type="exercise" id="exercise_id">
                <div data-type="problem" id="problem_id">
                  <span class="os-text">EA</span>
                  <span class="os-number">1.1</>
                  <span class="os-divider">. </span>
                  <div class="os-problem-container">
                    <p>example content</p>
                  </div>
                </div>
              </div>
            </section>
          </div>
          <div class="os-eoc os-exercise-set-b-container" data-type="composite-page" data-uuid-key=".exercise-set-b" id="composite-page-2">
            <section class="exercise-set-b">
              <div data-type="exercise" id="exercise_id">
                <div data-type="problem" id="problem_id">
                  <span class="os-text">EB</span>
                  <span class="os-number">1.1</>
                  <span class="os-divider">. </span>
                  <div class="os-problem-container">
                    <p>example content</p>
                  </div>
                </div>
              </div>
            </section>
          </div>
          <div class="os-eoc os-problem-set-a-container" data-type="composite-page" data-uuid-key=".problem-set-a" id="composite-page-3">
            <section class="problem-set-a">
              <div data-type="exercise" id="exercise_id">
                <div data-type="problem" id="problem_id">
                  <span class="os-text">PA</span>
                  <span class="os-number">1.1</>
                  <span class="os-divider">. </span>
                  <div class="os-problem-container">
                    <p>example content</p>
                  </div>
                </div>
              </div>
            </section>
          </div>
          <div class="os-eoc os-problem-set-b-container" data-type="composite-page" data-uuid-key=".problem-set-b" id="composite-page-4">
            <section class="problem-set-b">
              <div data-type="exercise" id="exercise_id">
                <div data-type="problem" id="problem_id">
                  <span class="os-text">PB</span>
                  <span class="os-number">1.1</>
                  <span class="os-divider">. </span>
                  <div class="os-problem-container">
                    <p>example content</p>
                  </div>
                </div>
              </div>
            </section>
          </div>
          <div class="os-eoc os-thought-provokers-container" data-type="composite-page" data-uuid-key=".thought-provokers" id="composite-page-5">
            <section class="thought-provokers">
              <div data-type="exercise" id="exercise_id">
                <div data-type="problem" id="problem_id">
                  <span class="os-text">TP</span>
                  <span class="os-number">1.1</>
                  <span class="os-divider">. </span>
                  <div class="os-problem-container">
                    <p>example content</p>
                  </div>
                </div>
              </div>
            </section>
          </div>
        </div>
      HTML
    )
  end

  it 'does nothing to exercises which do not need prefixes ' do
    described_class.new.bake(chapter: chapter_with_unprefixed_exercises, sections_prefixed: eoc_sections_prefixed)
    expect(chapter_with_unprefixed_exercises).to match_normalized_html(
      <<~HTML
        <div data-type="chapter">
          <div class="os-eoc os-multiple-choice-container" data-type="composite-page" data-uuid-key=".multiple-choice" id="composite-page-1">
            <section class="multiple-choice">
              <div data-type="exercise" id="exercise_id" class="os-hasSolution">
                <div data-type="problem" id="problem_id">
                  <a class="os-number" href="#exercise_id-solution">1.1</a>
                  <span class="os-divider">. </span>
                  <div class="os-problem-container">
                    <p>example content</p>
                  </div>
                </div>
              </div>
            </section>
          </div>
          <div class="os-eoc os-questions-container" data-type="composite-page" data-uuid-key=".questions" id="composite-page-2">
            <section class="questions">
              <div data-type="exercise" id="exercise_id" class="os-hasSolution">
                <div data-type="problem" id="problem_id">
                  <a class="os-number" href="#exercise_id-solution">1.1</a>
                  <span class="os-divider">. </span>
                  <div class="os-problem-container">
                    <p>example content</p>
                  </div>
                </div>
              </div>
            </section>
          </div>
        </div>
      HTML
    )
  end
end
