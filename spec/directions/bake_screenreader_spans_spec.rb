# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeScreenreaderSpans do

  before do
    stub_locales({
      'stepwise_step_label': 'Step'
    })
  end

  let(:book1) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div>hello <u data-effect="double-underline">world</u>. <u data-effect="underline">aaaaah</u></div>
        HTML
      )
    )
  end

  it 'works' do
    described_class.v1(book: book1)

    expect(book1.pages.first).to match_normalized_html(
      <<~HTML
        <div data-type="page">
          <div>hello <span data-screenreader-only="true">double underline</span><u data-effect="double-underline">world</u>. <span data-screenreader-only="true">underline</span><u data-effect="underline">aaaaah</u></div>
        </div>
      HTML
    )

  end

end
