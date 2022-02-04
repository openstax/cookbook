# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'namespace operations' do
  let(:book) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <span xmlns="http://www.w3.org/1999/xhtml"
                xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0"
                xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0"
                data-type="term"
                cmlnle:reference="Wundt, Wilhelm (1832-1920)"
                cxlxt:index="name"
                cxlxt:name="Wundta, Wilhelma">Wilhelma Wundta</span>
            <span xmlns="http://www.w3.org/1999/xhtml"
                xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0"
                xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0"
                cxlxt:index="foo">Other span</span>
        HTML
    ))
  end

  it 'can select elements by namespaced attributes' do
    expect(book.chapters.first.search("[cxlxt|index='name']").first.text).to eq 'Wilhelma Wundta'
  end
end
