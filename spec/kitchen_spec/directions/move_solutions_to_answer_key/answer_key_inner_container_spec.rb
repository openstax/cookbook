# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::AnswerKeyInnerContainer do

  let(:book) do
    book_containing(html:
      <<~HTML
        #{metadata_element}
          <div data-type="chapter">
            <div data-type="page">
              This is a page
            </div>
          </div>
      HTML
    )
  end

  let(:append_to) do
    new_element(
      <<~HTML
        <div class="heyhey"></div>
      HTML
    )
  end

  it 'v1 works for solution (plural)' do
    expect(
      described_class.v1(chapter: book.chapters.first, metadata_source: metadata_element, append_to: append_to)
    ).to match_snapshot_auto
  end

  it 'v1 works for solution (singular)' do
    expect(
      described_class.v1(
        chapter: book.chapters.first, metadata_source: metadata_element, append_to: append_to, solutions_plural: false
      )
    ).to match_snapshot_auto
  end
end
