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

  let(:missing_id_book) do
    book_containing(html:
      <<~HTML
        <a>skip this link</a>
        <a>[link]</a>
        <a href="">[link]</a>
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

  let(:book_with_sections_overwrite) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="page" id='?key'>1.21 Section About Decimals like 2.1 and 1.21</div>
          <a>skip this link</a>
          <a href='?key'>[link]</a>
          <a href='?other_key'>[link]</a>
          <a href='?foo_key'>[link]</a>
        </div>
        <div data-type="page" class="appendix" id='?foo_key'>Appendix A</div>
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

  context 'when link place holder is to be replaced' do
    before do
      book_with_sections_overwrite.pantry(name: :link_text).store('1.21 Section About Decimals like 2.1 and 1.21', label: 'key')
      book_with_sections_overwrite.pantry(name: :link_text).store('2.1 This label remains', label: 'other_key')
      book_with_sections_overwrite.pantry(name: :link_text).store('Appendix A', label: 'foo_key')
    end

    it 'bakes correctly' do
      described_class.v1(book: book_with_sections_overwrite, replace_section_link_text: true)
      expect(book_with_sections_overwrite.body).to match_snapshot_auto
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
      expect(book_with_cases.body).to match_snapshot_auto
    end
  end

  context 'when link has class' do
    before do
      book.pantry(name: :link_text).store('Example x.y', label: 'key')
      book.pantry(name: :link_type).store('example-target-label', label: 'key')
    end

    it 'bakes' do
      described_class.v1(book: book)
      expect(book.body).to match_snapshot_auto
    end
  end

  it 'logs a warning when href is invalid' do
    expect(Warning).to receive(:warn).with(
      "warning! could not find a replacement for '[link]' on an element with ID 'invalid_key'\n",
      { category: nil }
    )
    described_class.v1(book: invalid_book)
  end

  it 'logs a warning when link has no href' do
    expect(Warning).to receive(:warn).with(/warning! Link has no href on element: /,
                                           { category: nil }).twice
    described_class.v1(book: missing_id_book)
  end

end
