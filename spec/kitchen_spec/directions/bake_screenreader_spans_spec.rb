# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeScreenreaderSpans do

  before do
    stub_locales({
      'screenreader': {
        'end': 'end',
        'underline': 'underline',
        'double-underline': 'double underline',
        'public-domain': 'public domain text',
        'student-sample': 'student sample text',
        'annotation-text': 'annotated text'
      }
    })
  end

  let(:book1) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div>hello <u data-effect="double-underline">world</u>. <u data-effect="underline">underlined</u></div>
          <p class="public-domain">Proud Immigrant Citizen @primmcit</p>
          <p class="student-sample">Suddenly,<u data-effect="underline">stood</u> .</p>
          <p class="annotation-text">This response .</p>
        HTML
      )
    )
  end

  it 'works' do
    described_class.v1(book: book1)

    expect(book1.pages.first).to match_snapshot_auto

  end

end
