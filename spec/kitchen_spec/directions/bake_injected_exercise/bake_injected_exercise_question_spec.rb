# frozen_string_literal: true

RSpec.describe Kitchen::Directions::BakeInjectedExerciseQuestion do
  before do
    stub_locales({
      'exercise': 'Exercise',
      'problem': 'Problem'
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
                  <li data-type="question-answer" data-correctness="1.0" data-id="668499">
                    <div data-type="answer-content">all of the above - distractor</div>
                    <div data-type="answer-feedback">choice level feedback</div>
                  </li>
                </ol>
              </div>
            </div>
            <div data-type="injected-exercise" data-injected-from-nickname="singleMCWithDetailed" data-injected-from-version="2" data-injected-from-url="url" data-tags="tags" data-is-vocab="False">
              <div data-type="exercise-question" data-is-answer-order-important="True" data-formats="multiple-choice test-format" data-id="5">
                <div data-type="question-stimulus">i'm a question stimulus</div>
                <div data-type="question-stem">Testing a multiple choice question</div>
                <ol data-type="question-answers" type="a">
                  <li data-type="question-answer" data-correctness="0.0" data-id="668496">
                    <div data-type="answer-content">mean - i'm distractor</div>
                    <div data-type="answer-feedback">choice level feedback</div>
                  </li>
                  <li data-type="question-answer" data-correctness="1.0" data-id="668497">
                    <div data-type="answer-content">median - distractor</div>
                  </li>
                  <li data-type="question-answer" data-correctness="1.0" data-id="668498">
                    <div data-type="answer-content">mode - correct answer</div>
                    <div data-type="answer-feedback">choice level feedback</div>
                  </li>
                </ol>
                <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed">
                  detailed solution for MC
                </div>
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

  let(:book_with_exercise_with_two_solutions) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter"><div data-type="page" id="page_6dd92b44-db43-4254-a4db-45fb02eb773e">
          <section data-depth="1" id="auto_7335a4e5-b65f-438f-9e89-931000468b59_fs-idm265611728" class="review-questions">
            <h3 data-type="title">Review Questions</h3>
            <div data-type="injected-exercise" data-injected-from-nickname="singleFR" data-injected-from-version="2" data-injected-from-url="url" data-tags="type:practice all" data-is-vocab="False">
              <div data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response" data-id="1">
                <div data-type="question-stimulus">Question 1 stimulus</div>
                <div data-type="question-stem">Question 1</div>
                <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="summary">
                  solution 1
                </div>
                <div data-type="question-solution" data-solution-source="collaborator" data-solution-type="detailed">
                  solution 2
                </div>
              </div>
            </div>
          </section>
        <div></div>
      HTML
    )
  end

  it 'bakes' do
    book_with_injected_section.chapters.pages.injected_questions.each do |question|
      described_class.v1(question: question, number: question.count_in(:page))
    end
    expect(book_with_injected_section.search('section').first).to match_snapshot_auto
  end

  it 'bakes with dot after answer' do
    book_with_injected_section.chapters.pages.injected_questions.each do |question|
      described_class.v1(question: question, number: question.count_in(:page), options: { add_dot: true })
    end
    expect(book_with_injected_section.search('section').first).to match_snapshot_auto
  end

  it 'bakes without question number' do
    described_class.v1(question: exercise_no_question_number.injected_questions.first, number: 4, options: { only_number_solution: true })
    expect(exercise_no_question_number).to match_snapshot_auto
  end

  it 'bakes with problem prefix' do
    book_with_injected_section.chapters.pages.injected_questions.each do |question|
      described_class.v1(question: question, number: "1-#{question.count_in(:chapter)}", options: { problem_with_prefix: true })
    end
    expect(book_with_injected_section.search('section').first).to match_snapshot_auto
  end

  it 'bakes with two solutions' do
    book_with_exercise_with_two_solutions.chapters.pages.injected_questions.each do |question|
      described_class.v1(question: question, number: question.count_in(:page))
    end
    expect(book_with_exercise_with_two_solutions.search('section').first).to match_snapshot_auto
  end

  it 'bakes with suppressing_summary' do
    book_with_exercise_with_two_solutions.chapters.pages.injected_questions.each do |question|
      described_class.v1(question: question, number: question.count_in(:page), options: { suppress_summary: true })
    end
    expect(book_with_exercise_with_two_solutions.search('section').first).to match_snapshot_auto
  end

  it 'bakes with suppressing_detailed' do
    book_with_exercise_with_two_solutions.chapters.pages.injected_questions.each do |question|
      described_class.v1(question: question, number: question.count_in(:page), options: { suppress_detailed: true })
    end
    expect(book_with_exercise_with_two_solutions.search('section').first).to match_snapshot_auto
  end

  it 'bakes with uppercase answer letters' do
    book_with_injected_section.chapters.pages.injected_questions.each do |question|
      described_class.v1(question: question, number: question.count_in(:page), options: { answer_letter_upper: true })
    end
    expect(book_with_injected_section.search('section').first).to match_snapshot_auto
  end

  it 'bakes with answer_letter_only' do
    book_with_injected_section.chapters.pages.injected_questions.each do |question|
      described_class.v1(question: question, number: question.count_in(:page), options: { answer_letter_only: true })
    end
    expect(book_with_injected_section.search('section').first).to match_snapshot_auto
  end

  it 'bakes with prioritize_solution set to detailed' do
    book_with_exercise_with_two_solutions.chapters.pages.injected_questions.each do |question|
      described_class.v1(question: question, number: question.count_in(:page), options: { prioritize_solution: :detailed })
    end
    expect(book_with_exercise_with_two_solutions.search('section').first).to match_snapshot_auto
  end

  it 'bakes with prioritize_solution set to summary' do
    book_with_exercise_with_two_solutions.chapters.pages.injected_questions.each do |question|
      described_class.v1(question: question, number: question.count_in(:page), options: { prioritize_solution: :summary })
    end
    expect(book_with_exercise_with_two_solutions.search('section').first).to match_snapshot_auto
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
    expect(book_with_exercise_with_context_figure.search('section').first).to match_snapshot_auto
  end

  context 'when questions are in appendix' do
    let(:book_with_appendix_with_injected_section) do
      book_containing(html:
        <<~HTML
          <div data-type="page" id="page_abc123" class="appendix">
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
            </div>
          </div>
        HTML
      )
    end

    it 'stores link text' do
      question = book_with_appendix_with_injected_section.pages.injected_questions.first
      pantry = question.pantry(name: :link_text)
      expect(pantry).to receive(:store).with('Exercise 1.1', { label: 'auto_abc123_1' })
      described_class.v1(question: question, number: '1')
    end
  end

  context 'when questions are in preface' do
    let(:book_with_preface_with_injected_section) do
      book_containing(html:
        <<~HTML
          <div data-type="page" id="page_abc123" class="preface">
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
            </div>
          </div>
        HTML
      )
    end

    it 'stores link text' do
      question = book_with_preface_with_injected_section.pages.injected_questions.first
      pantry = question.pantry(name: :link_text)
      expect(pantry).to receive(:store).with('Exercise 1.1', { label: 'auto_abc123_1' })
      described_class.v1(question: question, number: '1')
    end
  end
end
