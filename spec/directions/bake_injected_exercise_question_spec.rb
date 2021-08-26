# frozen_string_literal: true

RSpec.describe Kitchen::Directions::BakeInjectedExerciseQuestion do
  before do
    stub_locales({})
  end

  let(:book_with_injected_section) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <section class="section-with-injected-exercises">
            <div data-type="injected-exercise" data-injected-from-nickname="multiFR" data-injected-from-version="2" data-injected-from-url="url" data-tags="type:practice all" data-is-vocab="False">
              <div data-type="exercise-stimulus">Exercise stimulus</div>
              <div data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response">
                <div data-type="question-stem">Question 1</div>
                <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed">
                  solution 1
                </div>
              </div>
              <div data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response">
                <div data-type="question-stem">Question 2</div>
                <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed">
                  solution 2
                </div>
              </div>
              <div data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response">
                <div data-type="question-stem">Question 3</div>
                <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed">
                  solution 3
                </div>
              </div>
            </div>
            <div data-type="injected-exercise" data-injected-from-nickname="singleFR" data-injected-from-version="2" data-injected-from-url="url" data-tags="type:practice all" data-is-vocab="False">
              <div data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response">
                <div data-type="question-stimulus">Question 1 stimulus</div>
                <div data-type="question-stem">Question 1</div>
                <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed">
                  solution 1
                </div>
              </div>
            </div>
            <div data-type="injected-exercise" data-injected-from-nickname="singleMC" data-injected-from-version="2" data-injected-from-url="url" data-tags="tags" data-is-vocab="False">
              <div data-type="exercise-question" data-is-answer-order-important="True" data-formats="multiple-choice test-format">
                <div data-type="question-stimulus">i'm a question stimulus</div>
                <div data-type="question-stem">Testing a multiple choice question</div>
                <ol data-type="question-answers" type="a">
                  <li data-type="question-answer" data-correctness="0.0" data-id="668496">
                    <div data-type="answer-content">mean - i'm distractor</div>
                    <div data-type="answer-feedback">choice level feedback</div>
                  </li>
                  <li data-type="question-answer" data-correctness="0.0" data-id="668497">
                    <div data-type="answer-content">median - distractor</div>
                  </li>
                  <li data-type="question-answer" data-correctness="1.0" data-id="668498">
                    <div data-type="answer-content">mode - correct answer</div>
                    <div data-type="answer-feedback">choice level feedback</div>
                  </li>
                  <li data-type="question-answer" data-correctness="0.0" data-id="668499">
                    <div data-type="answer-content">all of the above - distractor</div>
                    <div data-type="answer-feedback">choice level feedback</div>
                  </li>
                </ol>
              </div>
            </div>
            <div data-type="injected-exercise" data-injected-from-nickname="singleFR" data-injected-from-version="2" data-injected-from-url="url" data-tags="type:practice all" data-is-vocab="False">
              <div data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response">
                <div data-type="question-stem">question without solution</div>
              </div>
            </div>
          </section>
        HTML
      )
    )
  end

  let(:exercise_no_question_number) do
    book_containing(html:
      <<~HTML
        <div data-type="note">
          <div data-type="note-body">
            <div data-type="injected-exercise" data-injected-from-nickname="singleFR" data-injected-from-version="2" data-injected-from-url="url" data-tags="type:practice all" data-is-vocab="False">
              <div data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response">
                <div data-type="question-stimulus">Question 1 stimulus</div>
                <div data-type="question-stem">Question 1</div>
                <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed">
                  solution 1
                </div>
              </div>
            </div>
          </div>
        </div>
      HTML
    ).notes.first
  end

  it 'bakes' do
    book_with_injected_section.pages.first.injected_questions.each do |question|
      described_class.v1(question: question, number: question.count_in(:page))
    end
    expect(book_with_injected_section.search('section').first).to match_normalized_html(
      <<~HTML
        <section class="section-with-injected-exercises">
          <div data-type="injected-exercise" data-injected-from-nickname="multiFR" data-injected-from-version="2" data-injected-from-url="url" data-tags="type:practice all" data-is-vocab="False">
            <div data-type="exercise-stimulus">Exercise stimulus</div>
            <div class="os-hasSolution" data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response">
              <a class='os-number' href='#solution-ref'>1</a>
              <span class='os-divider'>. </span>
              <div class="os-problem-container">
                <div data-type="question-stem">Question 1</div>
              </div>
              <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed">
                <a class='os-number' href='#exercise-ref'>1</a>
                <span class='os-divider'>. </span>
                <div class="os-solution-container">
                solution 1
              </div>
              </div>
            </div>
            <div class="os-hasSolution" data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response">
              <a class='os-number' href='#solution-ref'>2</a>
              <span class='os-divider'>. </span>
              <div class="os-problem-container">
                <div data-type="question-stem">Question 2</div>
              </div>
              <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed">
                <a class='os-number' href='#exercise-ref'>2</a>
                <span class='os-divider'>. </span>
                <div class="os-solution-container">
                solution 2
              </div>
              </div>
            </div>
            <div class="os-hasSolution" data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response">
              <a class='os-number' href='#solution-ref'>3</a>
              <span class='os-divider'>. </span>
              <div class="os-problem-container">
                <div data-type="question-stem">Question 3</div>
              </div>
              <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed">
                <a class='os-number' href='#exercise-ref'>3</a>
                <span class='os-divider'>. </span>
                <div class="os-solution-container">
                solution 3
              </div>
              </div>
            </div>
          </div>
          <div data-type="injected-exercise" data-injected-from-nickname="singleFR" data-injected-from-version="2" data-injected-from-url="url" data-tags="type:practice all" data-is-vocab="False">
            <div class="os-hasSolution" data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response">
              <a class='os-number' href='#solution-ref'>4</a>
              <span class='os-divider'>. </span>
              <div class="os-problem-container">
                <div data-type="question-stimulus">Question 1 stimulus</div>
                <div data-type="question-stem">Question 1</div>
              </div>
              <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed">
                <a class='os-number' href='#exercise-ref'>4</a>
                <span class='os-divider'>. </span>
                <div class="os-solution-container">
                solution 1
              </div>
              </div>
            </div>
          </div>
          <div data-type="injected-exercise" data-injected-from-nickname="singleMC" data-injected-from-version="2" data-injected-from-url="url" data-tags="tags" data-is-vocab="False">
            <div class="os-hasSolution" data-type="exercise-question" data-is-answer-order-important="True" data-formats="multiple-choice test-format">
              <a class='os-number' href='#solution-ref'>5</a>
              <span class='os-divider'>. </span>
              <div class="os-problem-container">
                <div data-type="question-stimulus">i'm a question stimulus</div>
                <div data-type="question-stem">Testing a multiple choice question</div>
                <ol data-type="question-answers" type="a">
                  <li data-type="question-answer" data-correctness="0.0" data-id="668496">
                    <div data-type="answer-content">mean - i'm distractor</div>
                    <div data-type="answer-feedback">choice level feedback</div>
                  </li>
                  <li data-type="question-answer" data-correctness="0.0" data-id="668497">
                    <div data-type="answer-content">median - distractor</div>
                  </li>
                  <li data-type="question-answer" data-correctness="1.0" data-id="668498">
                    <div data-type="answer-content">mode - correct answer</div>
                    <div data-type="answer-feedback">choice level feedback</div>
                  </li>
                  <li data-type="question-answer" data-correctness="0.0" data-id="668499">
                    <div data-type="answer-content">all of the above - distractor</div>
                    <div data-type="answer-feedback">choice level feedback</div>
                  </li>
                </ol>
              </div>
              <div data-type="question-solution">
                <a class='os-number' href='#exercise-ref'>5</a>
                <span class='os-divider'>. </span>
                <div class="os-solution-container">c</div>
              </div>
            </div>
          </div>
          <div data-type="injected-exercise" data-injected-from-nickname="singleFR" data-injected-from-version="2" data-injected-from-url="url" data-tags="type:practice all" data-is-vocab="False">
            <div data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response">
              <span class='os-number'>6</span>
              <span class='os-divider'>. </span>
              <div class="os-problem-container">
                <div data-type="question-stem">question without solution</div>
              </div>
            </div>
          </div>
        </section>
      HTML
    )
  end

  it 'bakes without question number' do
    described_class.v1(question: exercise_no_question_number.injected_questions.first, number: 4, only_number_solution: true)
    expect(exercise_no_question_number).to match_normalized_html(
      <<~HTML
        <div data-type="note">
          <div data-type="note-body">
            <div data-injected-from-nickname="singleFR" data-injected-from-url="url" data-injected-from-version="2" data-is-vocab="False" data-tags="type:practice all" data-type="injected-exercise">
              <div class="os-hasSolution" data-formats="free-response" data-is-answer-order-important="False" data-type="exercise-question">
                <div class="os-problem-container">
                  <div data-type="question-stimulus">Question 1 stimulus</div>
                  <div data-type="question-stem">Question 1</div>
                </div>
                <div data-solution-source="collaborator" data-solution-type="detailed" data-type="question-solution">
                  <a class="os-number" href="#exercise-ref">4</a>
                  <span class="os-divider">. </span>
                  <div class="os-solution-container">
                  solution 1
                </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      HTML
    )
  end

  context 'when the question-answers list type is not lower alpha' do
    let(:question_with_all_correct) do
      book_containing(html:
        <<~HTML
          <div data-type="exercise-question">
            <div data-type="question-stem">test</div>
            <ol data-type="question-answers">
              <li data-type="question-answer" data-correctness="1.0">option a</li>
              <li data-type="question-answer" data-correctness="1.0">option b</li>
              <li data-type="question-answer" data-correctness="1.0">option c</li>
              <li data-type="question-answer" data-correctness="1.0">option d</li>
            </ol>
          </div>
        HTML
      ).injected_questions.first
    end

    it 'raises an error' do
      expect {
        described_class.v1(question: question_with_all_correct, number: 2)
      }.to raise_error('Unsupported list type for multiple choice options')
    end
  end
end
