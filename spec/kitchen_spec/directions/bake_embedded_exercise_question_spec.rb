# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeEmbeddedExerciseQuestion do
  let(:book_with_question) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <section>
            <div>Question</div>
          </section>
        HTML
      )
    )
  end

  context 'when question and number provided' do
    it 'bakes' do
      section = book_with_question.search('section').first!
      question = section.search('div').first!
      described_class.v1(question: question, number: 1, append_to: section)
      expect(book_with_question.pages.first).to match_snapshot_auto
    end
  end
end
