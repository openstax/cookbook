# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterIntroductions do
  before do
    stub_locales({
      'chapter_outline': 'Chapter Outline',
      'chapter_objectives': 'Chapter Objectives'
    })
  end

  let(:book) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <h1 data-type="document-title">Chapter 1 Title</h1>
          <div class="introduction" data-type="page" id="testid1">
            <div data-type="document-title">Introduction 1</div>
            <div data-type="description">trash this</div>
            <div data-type="abstract">and this</div>
            <div data-type="metadata">don't touch this</div>
            <figure class="splash">can't touch this (stop! hammer time)</figure>
            <figure>move this</figure>
            <div>content</div>
          </div>
          <div data-type="page">
            <div data-type="document-title" id="becomes-ref-link">should be objective 1.1</div>
          </div>
          <div data-type="page">
            <div data-type="document-title">should be objective 1.2</div>
          </div>
        </div>
        <div data-type="chapter">
          <h1 data-type="document-title">Chapter 2 Title</h1>
          <div class="introduction" data-type="page" id="testid2">
            <div data-type="document-title">Introduction 2</div>
            <div data-type="description">trash this</div>
            <div data-type="abstract">and this</div>
            <div>content</div>
          </div>
          <div data-type="page" id="testid3">
            <div data-type="document-title">should be objective 2.1</div>
          </div>
        </div>
      HTML
    )
  end

  context 'when v1 called on book with chapter objectives' do
    it 'works' do
      described_class.v1(book: book)
      expect(book.body).to match_snapshot_auto
    end

    it 'updates selectors' do
      expect { described_class.v1(book: book) }.to change {
        book.selectors.title_in_introduction_page
      }.from(".//*[@data-type='document-title']").to(".intro-text > [data-type='document-title']")
    end
  end
end
