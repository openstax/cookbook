# frozen_string_literal: true

RSpec.describe Kitchen::Directions::AddInjectedExerciseId do

  let(:book_with_injected_section) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter"><div data-type="page" id="page_abc123">
          <section class="section-with-injected-exercises">
            <div data-type="injected-exercise" data-injected-from-nickname="multiFR" data-injected-from-version="2" data-injected-from-url="url" data-tags="type:practice all" data-is-vocab="False">
              <div data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response" data-id="1">
                <div data-type="question-stem">Question 1</div>
              </div>
              <div data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response" data-id="2">
                <div data-type="question-stem">Question 2</div>
              </div>
            </div>
          </section>
        </div></div>
      HTML
    )
  end

  it 'bakes' do
    book_with_injected_section.chapters.pages.injected_questions.each do |question|
      described_class.v1(question: question)
    end
    expect(book_with_injected_section.search('section').first).to match_normalized_html(
      <<~HTML
        <section class="section-with-injected-exercises">
          <div data-type="injected-exercise" data-injected-from-nickname="multiFR" data-injected-from-version="2" data-injected-from-url="url" data-tags="type:practice all" data-is-vocab="False">
            <div data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response" id="auto_abc123_1" data-id="1">
              <div data-type="question-stem">Question 1</div>
            </div>
            <div data-type="exercise-question" data-is-answer-order-important="False" data-formats="free-response" id="auto_abc123_2" data-id="2">
              <div data-type="question-stem">Question 2</div>
            </div>
          </div>
        </section>
      HTML
    )
  end
end
