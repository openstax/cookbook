# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeOrderHeaders do
  let(:page_with_headers) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <h3>The top title within the page</h3>
          <div>Body of introduction
            <h6>Subtitle</h6>
            <p>a paragraph</p>
          </div>
          <h3 data-type="document-title">wow another header</h3>
          <h5>subheader also</h5>
          <div><h6>subtitle subtitle</h6><p>paragraph</p>
            <h6>here we see a subtitle</h6>
          </div>
        HTML
      )
    ).pages.first
  end

  it 'works' do
    described_class.v1(within: page_with_headers)
    expect(page_with_headers).to match_snapshot_auto
  end
end
