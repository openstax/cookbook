# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterIntroductions do
  before do
    stub_locales({
      'chapter_outline': 'Chapter Outline',
      'notes': {
        'chapter-objectives': 'Chapter Objectives'
      }
    })
  end

  let(:book_v1) do
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

  let(:book_with_diff_order) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <h1 data-type="document-title">Chapter 1 Title</h1>
          <div class="introduction" data-type="page">
            <div data-type="document-title">Introduction</div>
            <figure class="splash">
              <div data-type="title">Blood Pressure</div>
              <figcaption>A proficiency in anatomy and physiology... (credit: Bryan Mason/flickr)</figcaption>
              <span data-type="media" data-alt="This photo shows a nurse taking a woman’s...">
              <img src="ccc4ed14-6c87-408b-9934-7a0d279d853a/100_Blood_Pressure.jpg" data-media-type="image/jpg" alt="This photo shows a nurse taking..." />
              </span>
            </figure>
            <div data-type="note" class="chapter-objectives">
              <div data-type="title">Chapter Objectives</div>
              <p>After studying this chapter, you will be able to:</p>
              <ul>
                <li>Distinguish between anatomy and physiology, and identify several branches of each</li>
              </ul>
            </div>
            <p id="123">Though you may approach a course in anatomy and physiology...</p>
            <p id="123">This chapter begins with an overview of anatomy and...</p>
          </div>
        </div>
      HTML
    )
  end

  let(:book_with_intro_objectives) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div class="introduction" data-type="page">
            <div data-type="document-title">Introduction 1</div>
            <div data-type="description">trash this</div>
            <div data-type="abstract">and this</div>
            <div data-type="metadata">don't touch this</div>
            <figure class="splash">can't touch this (stop! hammer time)</figure>
            <figure>move this</figure>
            <div>content</div>
            <div data-type="note" data-has-label="true" id="1" class="chapter-objectives">
              <div data-type="title">Chapter Objectives</div>
              <p>Some Text</p>
              <ul>
                <li>Some List</li>
              </ul>
            </div>
          </div>
        </div>
      HTML
    )
  end

  context 'when v2 called on book with chapter objectives' do
    it 'with chapter outline' do
      described_class.v2(
        book: book_with_diff_order,
        strategy_options: { strategy: :default, bake_chapter_outline: true, introduction_order: :v2 }
      )
      expect(book_with_diff_order.body).to match_normalized_html(
        <<~HTML
          <body>
            <div data-type="chapter">
              <h1 data-type="document-title">Chapter 1 Title</h1>
              <div class="introduction" data-type="page">
                <figure class="splash">
                  <div data-type="title">Blood Pressure</div>
                  <figcaption>A proficiency in anatomy and physiology... (credit: Bryan Mason/flickr)</figcaption>
                  <span data-type="media" data-alt="This photo shows a nurse taking a woman&#x2019;s...">
                  <img src="ccc4ed14-6c87-408b-9934-7a0d279d853a/100_Blood_Pressure.jpg" data-media-type="image/jpg" alt="This photo shows a nurse taking..."/>
                  </span>
                </figure>
                <div class="intro-body">
                  <div class="os-chapter-outline">
                    <h3 class="os-title">Chapter Outline</h3>
                    <div data-type="note" class="chapter-objectives">
                      <h3 class="os-title" data-type="title">
                        <span class="os-title-label">Chapter Objectives</span>
                      </h3>
                      <div class="os-note-body">
                        <p>After studying this chapter, you will be able to:</p>
                        <ul>
                          <li>Distinguish between anatomy and physiology, and identify several branches of each</li>
                        </ul>
                      </div>
                    </div>
                  </div>
                  <div class="intro-text">
                    <h2 data-type="document-title"><span data-type="" itemprop="" class="os-text">Introduction</span></h2>
                    <p id="123">Though you may approach a course in anatomy and physiology...</p>
                    <p id="123_copy_1">This chapter begins with an overview of anatomy and...</p>
                  </div>
                </div>
              </div>
            </div>
          </body>
        HTML
      )
    end

    it 'without chapter outline' do
      described_class.v2(book: book_with_diff_order)
      expect(book_with_diff_order.body).to match_normalized_html(
        <<~HTML
          <body>
            <div data-type="chapter">
              <h1 data-type="document-title">Chapter 1 Title</h1>
              <div class="introduction" data-type="page">
                <figure class="splash">
                  <div data-type="title">Blood Pressure</div>
                  <figcaption>A proficiency in anatomy and physiology... (credit: Bryan Mason/flickr)</figcaption>
                  <span data-type="media" data-alt="This photo shows a nurse taking a woman&#x2019;s...">
                  <img src="ccc4ed14-6c87-408b-9934-7a0d279d853a/100_Blood_Pressure.jpg" data-media-type="image/jpg" alt="This photo shows a nurse taking..."/>
                  </span>
                </figure>
                <div class="intro-body">
                  <div data-type="note" class="chapter-objectives">
                    <h3 class="os-title" data-type="title">
                      <span class="os-title-label">Chapter Objectives</span>
                    </h3>
                    <div class="os-note-body">
                      <p>After studying this chapter, you will be able to:</p>
                      <ul>
                        <li>Distinguish between anatomy and physiology, and identify several branches of each</li>
                      </ul>
                    </div>
                  </div>
                  <div class="intro-text">
                    <h2 data-type="document-title"><span data-type="" itemprop="" class="os-text">Introduction</span></h2>
                    <p id="123">Though you may approach a course in anatomy and physiology...</p>
                    <p id="123_copy_1">This chapter begins with an overview of anatomy and...</p>
                  </div>
                </div>
              </div>
            </div>
          </body>
        HTML
      )
    end
  end

  context 'when v2 is called on a book without chapter-objectives' do
    it 'works' do
      described_class.v2(
        book: book_with_intro_objectives, strategy_options: { strategy: :none, introduction_order: :v2 }
      )
      expect(book_with_intro_objectives.body).to match_normalized_html(
        <<~HTML
          <body>
            <div data-type="chapter">
              <div class="introduction" data-type="page">
                <div data-type="metadata">don't touch this</div>
                <figure class="splash">can't touch this (stop! hammer time)</figure>
                <div class="intro-body">
                <div class="chapter-objectives" data-has-label="true" data-type="note" id="1">
                  <div data-type="title">Chapter Objectives</div>
                  <p>Some Text</p>
                  <ul>
                    <li>Some List</li>
                  </ul>
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
            </div>
          </body>
        HTML
      )
    end

    it 'unknown strategy raises' do
      expect {
        described_class.v2(book: book_with_intro_objectives, strategy_options: { strategy: :hello })
      }.to raise_error('No such strategy')
    end
  end

  context 'when v2 is called with strategy: add_objectives' do
    it 'works' do
      described_class.v2(
        book: book_v1, strategy_options: {
          strategy: :add_objectives,
          bake_chapter_outline: true,
          introduction_order: :v1
        }
      )
      expect(book_v1.body).to match_normalized_html(
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
  end
end
