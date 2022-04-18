# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BookAnswerKeyContainer do

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

  it 'v1 works' do
    expect(described_class.v1(book: book)).to match_snapshot_auto
  end

  it 'v1 generates container with solution (singular) class' do
    expect(described_class.v1(book: book, solutions_plural: false)).to match_snapshot_auto
  end
end
