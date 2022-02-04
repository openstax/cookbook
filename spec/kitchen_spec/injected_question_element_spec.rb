# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::InjectedQuestionElement do

  let(:question_with_all_correct) do
    book_containing(html:
      <<~HTML
        <div data-type="exercise-question">
          <div data-type="question-stem">test</div>
          <ol data-type="question-answers" type="a">
            <li data-type="question-answer" data-correctness="1.0">option a</li>
            <li data-type="question-answer" data-correctness="1.0">option b</li>
            <li data-type="question-answer" data-correctness="1.0">option c</li>
            <li data-type="question-answer" data-correctness="1.0">option d</li>
          </ol>
        </div>
      HTML
    ).injected_questions.first
  end

  let(:question_without_correctness) do
    book_containing(html:
      <<~HTML
        <div data-type="exercise-question">
          <div data-type="question-stem">test</div>
          <ol data-type="question-answers" type="a">
            <li data-type="question-answer" data-correctness="0.0">option a</li>
            <li data-type="question-answer" data-correctness="0.0">option b</li>
            <li data-type="question-answer">option c</li>
            <li data-type="question-answer">option d</li>
          </ol>
        </div>
      HTML
    ).injected_questions.first
  end

  let(:question_with_some_correct) do
    book_containing(html:
      <<~HTML
        <div data-type="exercise-question">
          <div data-type="question-stem">test</div>
          <ol data-type="question-answers" type="a">
            <li data-type="question-answer" data-correctness="1.0">option a</li>
            <li data-type="question-answer" data-correctness="0.0">option b</li>
            <li data-type="question-answer" data-correctness="0.0">option c</li>
            <li data-type="question-answer" data-correctness="1.0">option d</li>
          </ol>
        </div>
      HTML
    ).injected_questions.first
  end

  let(:question_with_one_correct) do
    book_containing(html:
      <<~HTML
        <div data-type="exercise-question">
          <div data-type="question-stem">test</div>
          <ol data-type="question-answers" type="a">
            <li data-type="question-answer" data-correctness="0.0">option a</li>
            <li data-type="question-answer" data-correctness="0.0">option b</li>
            <li data-type="question-answer" data-correctness="0.0">option c</li>
            <li data-type="question-answer" data-correctness="1.0">option d</li>
          </ol>
        </div>
      HTML
    ).injected_questions.first
  end

  describe '#correct_answer_letters' do
    it 'returns a-d if all correct' do
      alphabet = *('a'..'z')
      expect(question_with_all_correct.correct_answer_letters(alphabet)).to eq(%w[a b c d])
    end

    it 'returns empty array if none correct' do
      alphabet = *('a'..'z')
      expect(question_without_correctness.correct_answer_letters(alphabet)).to eq(%w[])
    end

    it 'returns a,d if a,d correct' do
      alphabet = *('a'..'z')
      expect(question_with_some_correct.correct_answer_letters(alphabet)).to eq(%w[a d])
    end

    it 'returns just one right answer' do
      alphabet = *('a'..'z')
      expect(question_with_one_correct.correct_answer_letters(alphabet)).to eq(%w[d])
    end
  end
end
