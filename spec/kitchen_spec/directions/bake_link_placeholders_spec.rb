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

  let(:book_with_cases) do
    book_containing(html:
      <<~HTML
        <a>skip this link</a>
        <a href='?other_key'>[link]</a>
        <a xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" cmlnle:case="genitive" href='?other_key'>[link]</a>
        <a case="locative" href='?next_key'>[link]</a>
      HTML
    )
  end

  context 'when book do not use cases' do
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
  end

  context 'when book uses cases' do
    before do
      book_with_cases.pantry(name: :nominative_link_text).store('Przykład x.y', label: 'other_key')
      book_with_cases.pantry(name: :genitive_link_text).store('Przykładu x.y', label: 'other_key')
      book_with_cases.pantry(name: :locative_link_text).store('Przykładzie x.y', label: 'next_key')
    end

    it 'bakes' do
      described_class.v1(book: book_with_cases, cases: true)
      expect(book_with_cases.body).to match_normalized_html(
        <<~HTML
          <body>
            <a>skip this link</a>
            <a href='?other_key'>Przykład x.y</a>
            <a xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" cmlnle:case="genitive" href='?other_key'>Przykładu x.y</a>
            <a case="locative" href='?next_key'>Przykładzie x.y</a>
          </body>
        HTML
      )
    end
  end

  it 'logs a warning' do
    allow($stdout).to receive(:puts)
    expect($stdout).to receive(:puts).with("warning! could not find a replacement for '[link]' on an element with ID 'invalid_key'")
    described_class.v1(book: invalid_book)
  end
end
