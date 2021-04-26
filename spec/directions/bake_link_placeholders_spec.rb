# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeLinkPlaceholders do
  let(:book) do
    book_containing(html:
      <<~HTML
        <a>skip this link</a>
        <a href='?key'>[link]</a>
      HTML
    )
  end

  let(:invalid_book) do
    book_containing(html:
      <<~HTML
        <a>skip this link</a>
        <a href='?invalid_key'>[link]</a>
      HTML
    )
  end

  before do
    book.pantry(name: :link_text).store('Example x.y', label: 'key')
  end

  it 'bakes' do
    described_class.v1(book: book)
    expect(book.body).to match_normalized_html(
      <<~HTML
        <body>
          <a>skip this link</a>
          <a href='?key'>Example x.y</a>
        </body>
      HTML
    )
  end

  it 'logs a warning' do
    allow($stdout).to receive(:puts)
    expect($stdout).to receive(:puts).with("warning! could not find a replacement for '[link]' on an element with ID 'invalid_key'")
    described_class.v1(book: invalid_book)
  end
end
