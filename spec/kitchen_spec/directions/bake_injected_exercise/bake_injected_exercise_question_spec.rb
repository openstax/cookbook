# frozen_string_literal: true

RSpec.describe Kitchen::Directions::BakeInjectedExerciseQuestion do
  before do
    stub_locales({
      'exercise': 'Exercise'
    })
  end

  let(:book_with_injected_section) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter"><div data-type="page" id="page_abc123">
          <section class="section-with-injected-exercises">
            <div data-type="injected-exercise" data-injected-from-nickname="multiFR" data-injected-from-version="2" data-injected-from-url="url" data-tags="type:practice all" data-is-vocab="False">
              <div data-type="exercise-stimulus">Exercise stimulus</div>
              <div data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response" data-id="1">
                <div data-type="question-stem">Question 1</div>
                <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed">
                  solution 1
                </div>
              </div>
              <div data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response" data-id="2">
                <div data-type="question-stem">Question 2</div>
                <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed">
                  solution 2
                </div>
              </div>
              <div data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response" data-id="3">
                <div data-type="question-stem">Question 3</div>
                <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed">
                  solution 3
                </div>
              </div>
            </div>
            <div data-type="injected-exercise" data-injected-from-nickname="singleFR" data-injected-from-version="2" data-injected-from-url="url" data-tags="type:practice all" data-is-vocab="False">
              <div data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response" data-id="4">
                <div data-type="question-stimulus">Question 1 stimulus</div>
                <div data-type="question-stem">Question 1</div>
                <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed">
                  solution 1
                </div>
              </div>
            </div>
            <div data-type="injected-exercise" data-injected-from-nickname="singleMC" data-injected-from-version="2" data-injected-from-url="url" data-tags="tags" data-is-vocab="False">
              <div data-type="exercise-question" data-is-answer-order-important="True" data-formats="multiple-choice test-format" data-id="5">
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
              <div data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response" data-id="6">
                <div data-type="question-stem">question without solution</div>
              </div>
            </div>
          </section>
        </div></div>
      HTML
    )
  end

  let(:book_with_exercise_with_context_figure) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter"><div data-type="page" id="page_6dd92b44-db43-4254-a4db-45fb02eb773e">
          <section data-depth="1" id="auto_7335a4e5-b65f-438f-9e89-931000468b59_fs-idm265611728" class="review-questions"><h3 data-type="title">Review Questions</h3>
            <div data-type="injected-exercise" data-injected-from-nickname="WH-Ch01-Mod01-VBQ01" data-injected-from-version="7" data-injected-from-url="https://exercises.openstax.org/api/exercises?q=nickname:WH-Ch01-Mod01-VBQ01" data-tags="context-cnxmod:7335a4e5-b65f-438f-9e89-931000468b59 blooms:4 context-cnxfeature:Figure01_01_NewWorld time:medium assignment-type:homework all type:practice" data-is-vocab="false">
            <div data-type="exercise-question" data-is-answer-order-important="false" data-formats="free-response" data-id="181017">
                <div data-type="exercise-context" data-context-module="7335a4e5-b65f-438f-9e89-931000468b59" data-context-feature="Figure01_01_NewWorld">Refer to <a class="autogenerated-content" href="#auto_7335a4e5-b65f-438f-9e89-931000468b59_Figure01_01_NewWorld">Figure 1.4</a></div>
                <div data-type="question-stem">Review the map. Based on the map, what seems to be most common about the countries that leaned towards authoritarianism in the late 1920s and early 1930s?</div>
                </div>
            </div><div data-type="injected-exercise" data-injected-from-nickname="WH-Ch01-Mod01-VBQ02" data-injected-from-version="2" data-injected-from-url="https://exercises.openstax.org/api/exercises?q=nickname:WH-Ch01-Mod01-VBQ02" data-tags="blooms:4 time:medium assignment-type:homework all type:practice" data-is-vocab="false">
            <div data-type="exercise-question" data-is-answer-order-important="false" data-formats="free-response" data-id="181021">
                <div data-type="question-stem">Review the chart. Considering the data provided, what does the trend suggest about the intersection of economics and politics in interwar Germany?</div>
                </div>
            </div>
          </section>
        <div></div>
      HTML
    )
  end

  let(:exercise_no_question_number) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter"><div data-type="page" id="page_abc123">
          <div data-type="note" id="auto_dce456">
            <div data-type="note-body">
              <div data-type="injected-exercise" data-injected-from-nickname="singleFR" data-injected-from-version="2" data-injected-from-url="url" data-tags="type:practice all" data-is-vocab="False">
                <div data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response" data-id="1">
                  <div data-type="question-stimulus">Question 1 stimulus</div>
                  <div data-type="question-stem">Question 1</div>
                  <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed">
                    solution 1
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div></div>
      HTML
    ).chapters.pages.notes.first
  end

  it 'bakes' do
    book_with_injected_section.chapters.pages.injected_questions.each do |question|
      described_class.v1(question: question, number: question.count_in(:page))
    end
    expect(book_with_injected_section.search('section').first).to match_normalized_html(
      <<~HTML
        <section class="section-with-injected-exercises">
          <div data-type="injected-exercise" data-injected-from-nickname="multiFR" data-injected-from-version="2" data-injected-from-url="url" data-tags="type:practice all" data-is-vocab="False">
            <div data-type="exercise-stimulus">Exercise stimulus</div>
            <div class="os-hasSolution" data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response" id="auto_abc123_1" data-id="1">
              <a class='os-number' href='#auto_abc123_1-solution'>1</a>
              <span class='os-divider'>. </span>
              <div class="os-problem-container">
                <div data-type="question-stem">Question 1</div>
              </div>
              <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed" id="auto_abc123_1-solution">
                <a class='os-number' href='#auto_abc123_1'>1</a>
                <span class='os-divider'>. </span>
                <div class="os-solution-container">
                  solution 1
                </div>
              </div>
            </div>
            <div class="os-hasSolution" data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response" id="auto_abc123_2" data-id="2">
              <a class='os-number' href='#auto_abc123_2-solution'>2</a>
              <span class='os-divider'>. </span>
              <div class="os-problem-container">
                <div data-type="question-stem">Question 2</div>
              </div>
              <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed" id="auto_abc123_2-solution">
                <a class='os-number' href='#auto_abc123_2'>2</a>
                <span class='os-divider'>. </span>
                <div class="os-solution-container">
                  solution 2
                </div>
              </div>
            </div>
            <div class="os-hasSolution" data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response" id="auto_abc123_3" data-id="3">
              <a class='os-number' href='#auto_abc123_3-solution'>3</a>
              <span class='os-divider'>. </span>
              <div class="os-problem-container">
                <div data-type="question-stem">Question 3</div>
              </div>
              <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed" id="auto_abc123_3-solution">
                <a class='os-number' href='#auto_abc123_3'>3</a>
                <span class='os-divider'>. </span>
                <div class="os-solution-container">
                  solution 3
                </div>
              </div>
            </div>
          </div>
          <div data-type="injected-exercise" data-injected-from-nickname="singleFR" data-injected-from-version="2" data-injected-from-url="url" data-tags="type:practice all" data-is-vocab="False">
            <div class="os-hasSolution" data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response" id="auto_abc123_4" data-id="4">
              <a class='os-number' href='#auto_abc123_4-solution'>4</a>
              <span class='os-divider'>. </span>
              <div class="os-problem-container">
                <div data-type="question-stimulus">Question 1 stimulus</div>
                <div data-type="question-stem">Question 1</div>
              </div>
              <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed" id="auto_abc123_4-solution">
                <a class='os-number' href='#auto_abc123_4'>4</a>
                <span class='os-divider'>. </span>
                <div class="os-solution-container">
                  solution 1
                </div>
              </div>
            </div>
          </div>
          <div data-type="injected-exercise" data-injected-from-nickname="singleMC" data-injected-from-version="2" data-injected-from-url="url" data-tags="tags" data-is-vocab="False">
            <div class="os-hasSolution" data-type="exercise-question" data-is-answer-order-important="True" data-formats="multiple-choice test-format" id="auto_abc123_5" data-id="5">
              <a class='os-number' href='#auto_abc123_5-solution'>5</a>
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
              <div data-type="question-solution" id="auto_abc123_5-solution">
                <a class='os-number' href='#auto_abc123_5'>5</a>
                <span class='os-divider'>. </span>
                <div class="os-solution-container">c</div>
              </div>
            </div>
          </div>
          <div data-type="injected-exercise" data-injected-from-nickname="singleFR" data-injected-from-version="2" data-injected-from-url="url" data-tags="type:practice all" data-is-vocab="False">
            <div data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response" id="auto_abc123_6" data-id="6">
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
        <div data-type="note" id="auto_dce456">
          <div data-type="note-body">
            <div data-injected-from-nickname="singleFR" data-injected-from-url="url" data-injected-from-version="2" data-is-vocab="False" data-tags="type:practice all" data-type="injected-exercise">
              <div class="os-hasSolution" data-formats="free-response" data-is-answer-order-important="False" data-type="exercise-question" id="auto_abc123_1" data-id="1">
                <div class="os-problem-container">
                  <div data-type="question-stimulus">Question 1 stimulus</div>
                  <div data-type="question-stem">Question 1</div>
                </div>
                <div data-solution-source="collaborator" data-solution-type="detailed" data-type="question-solution" id="auto_abc123_1-solution">
                  <a class="os-number" href="#auto_abc123_1">4</a>
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
          <div data-type="chapter"><div data-type="page" id="page_abc123">
            <div data-type="exercise-question">
              <div data-type="question-stem">test</div>
              <ol data-type="question-answers">
                <li data-type="question-answer" data-correctness="1.0">option a</li>
                <li data-type="question-answer" data-correctness="1.0">option b</li>
                <li data-type="question-answer" data-correctness="1.0">option c</li>
                <li data-type="question-answer" data-correctness="1.0">option d</li>
              </ol>
            </div>
          </div></div>
        HTML
      ).chapters.pages.injected_questions.first
    end

    it 'raises an error' do
      expect {
        described_class.v1(question: question_with_all_correct, number: 2)
      }.to raise_error('Unsupported list type for multiple choice options')
    end

    it 'stores link text' do
      question = book_with_injected_section.chapters.pages.injected_questions.first
      pantry = question.pantry(name: :link_text)
      expect(pantry).to receive(:store).with('Exercise 1.1', { label: 'auto_abc123_1' })
      described_class.v1(question: question, number: '1')
    end
  end

  it 'moves `exercise-context` to exercises question after the problem number if there is one present' do
    book_with_exercise_with_context_figure.chapters.pages.injected_questions.each do |question|
      described_class.v1(question: question, number: question.count_in(:page))
    end
    expect(book_with_exercise_with_context_figure.search('section').first).to match_normalized_html(
      <<~HTML
        <section data-depth="1" id="auto_7335a4e5-b65f-438f-9e89-931000468b59_fs-idm265611728" class="review-questions"><h3 data-type="title">Review Questions</h3>
            <div data-injected-from-nickname="WH-Ch01-Mod01-VBQ01" data-injected-from-url="https://exercises.openstax.org/api/exercises?q=nickname:WH-Ch01-Mod01-VBQ01" data-injected-from-version="7" data-is-vocab="false" data-tags="context-cnxmod:7335a4e5-b65f-438f-9e89-931000468b59 blooms:4 context-cnxfeature:Figure01_01_NewWorld time:medium assignment-type:homework all type:practice" data-type="injected-exercise">
              <div data-formats="free-response" data-id="181017" data-is-answer-order-important="false" data-type="exercise-question" id="auto_6dd92b44-db43-4254-a4db-45fb02eb773e_181017">
                <span class="os-number">1</span>
                <span class="os-divider">. </span>
                <div class="os-problem-container">
                  <div data-context-feature="Figure01_01_NewWorld" data-context-module="7335a4e5-b65f-438f-9e89-931000468b59" data-type="exercise-context">Refer to <a class="autogenerated-content" href="#auto_7335a4e5-b65f-438f-9e89-931000468b59_Figure01_01_NewWorld">Figure 1.4</a></div>
                  <span class="os-divider">. </span>
                  <div data-type="question-stem">Review the map. Based on the map, what seems to be most common about the countries that leaned towards authoritarianism in the late 1920s and early 1930s?</div>
                </div>
              </div>
            </div>
            <div data-injected-from-nickname="WH-Ch01-Mod01-VBQ02" data-injected-from-url="https://exercises.openstax.org/api/exercises?q=nickname:WH-Ch01-Mod01-VBQ02" data-injected-from-version="2" data-is-vocab="false" data-tags="blooms:4 time:medium assignment-type:homework all type:practice" data-type="injected-exercise">
              <div data-formats="free-response" data-id="181021" data-is-answer-order-important="false" data-type="exercise-question" id="auto_6dd92b44-db43-4254-a4db-45fb02eb773e_181021">
                <span class="os-number">2</span>
                <span class="os-divider">. </span>
                <div class="os-problem-container">
                  <div data-type="question-stem">Review the chart. Considering the data provided, what does the trend suggest about the intersection of economics and politics in interwar Germany?</div>
                </div>
              </div>
            </div>
          </section>
      HTML
    )
  end
end
