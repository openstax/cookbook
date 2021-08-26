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
          <div class="introduction" data-type="page">
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
          <div class="introduction" data-type="page">
            <div data-type="document-title">Introduction 2</div>
            <div data-type="description">trash this</div>
            <div data-type="abstract">and this</div>
            <div>content</div>
          </div>
          <div data-type="page">
            <div data-type="document-title">should be objective 2.1</div>
          </div>
        </div>
      HTML
    )
  end

  context 'when v1 called on book with chapter objectives' do
    it 'works' do
      described_class.v1(book: book)
      expect(book.body).to match_normalized_html(
        <<~HTML
          <body>
            <div data-type="chapter">
              <h1 data-type="document-title">Chapter 1 Title</h1>
              <div class="introduction" data-type="page">
                <div data-type="metadata">don't touch this</div>
                <figure class="splash">can't touch this (stop! hammer time)</figure>
                <div class="intro-body">
                  <div class="os-chapter-outline">
                    <h3 class="os-title">Chapter Outline</h3>
                    <div class="os-chapter-objective">
                      <a class="os-chapter-objective" href="#becomes-ref-link">
                        <span class="os-number">1.1</span>
                        <span class="os-divider"> </span>
                        <span class="os-text" data-type="" itemprop="">should be objective 1.1</span>
                      </a>
                    </div>
                    <div class="os-chapter-objective">
                      <a class="os-chapter-objective" href="#">
                        <span class="os-number">1.2</span>
                        <span class="os-divider"> </span>
                        <span class="os-text" data-type="" itemprop="">should be objective 1.2</span>
                      </a>
                    </div>
                  </div>
                  <div class="intro-text">
                    <h2 data-type="document-title">
                      <span class="os-text" data-type="" itemprop="">Introduction 1</span>
                    </h2>
                    <figure>move this</figure>
                    <div>content</div>
                  </div>
                </div>
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
              <div class="introduction" data-type="page">
                <div class="intro-body">
                  <div class="os-chapter-outline">
                    <h3 class="os-title">Chapter Outline</h3>
                    <div class="os-chapter-objective">
                      <a class="os-chapter-objective" href="#">
                        <span class="os-number">2.1</span>
                        <span class="os-divider"> </span>
                        <span class="os-text" data-type="" itemprop="">should be objective 2.1</span>
                      </a>
                    </div>
                  </div>
                  <div class="intro-text">
                    <h2 data-type="document-title">
                      <span class="os-text" data-type="" itemprop="">Introduction 2</span>
                    </h2>
                    <div>content</div>
                  </div>
                </div>
              </div>
              <div data-type="page">
                <div data-type="document-title">should be objective 2.1</div>
              </div>
            </div>
          </body>
        HTML
      )
    end

    it 'updates selectors' do
      expect { described_class.v1(book: book) }.to change {
        book.selectors.title_in_introduction_page
      }.from("./*[@data-type = 'document-title']").to(".intro-text > [data-type='document-title']")
    end
  end
end
