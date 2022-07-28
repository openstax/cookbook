# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterIntroductions do
  before do
    stub_locales({
      'chapter': 'Chapter',
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
          <div class="introduction" data-type="page" id="ipId">
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

  let(:book_with_diff_order) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <h1 data-type="document-title">Chapter 1 Title</h1>
          <div class="introduction" data-type="page" id="testid1">
            <div data-type="document-title" id="testid">Introduction</div>
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
        <h1 data-type="document-title">Chapter 1 Title</h1>
          <div class="introduction" data-type="page" id="testid">
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

  let(:book_with_unit_opener) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <h1 data-type="document-title">Chapter 1 Title</h1>
          <div class="introduction" data-type="page" id="testid1">
            <div data-type="document-title">Introduction</div>
            <div data-type="note" class="unit-opener">
              <div data-type="title">Understanding the Marketplace</div>
              <p>Welcome to Part II of Principles of Marketing...</p>
            </div>
            <figure class="splash">
              <div data-type="title">Blood Pressure</div>
              <figcaption>A proficiency in anatomy and physiology... (credit: Bryan Mason/flickr)</figcaption>
              <span data-type="media" data-alt="This photo shows a nurse taking a woman’s...">
              <img src="ccc4ed14-6c87-408b-9934-7a0d279d853a/100_Blood_Pressure.jpg" data-media-type="image/jpg" alt="This photo shows a nurse taking..." />
              </span>
            </figure>
            <p id="123">Though you may approach a course in anatomy and physiology...</p>
            <p id="123">This chapter begins with an overview of anatomy and...</p>
          </div>
        </div>
      HTML
    )
  end

  context 'when v2 called on book with chapter objectives' do
    it 'with chapter outline' do
      described_class.v2(
        book: book_with_diff_order,
        options: { strategy: :default, bake_chapter_outline: true, introduction_order: :v2 }
      )
      expect(book_with_diff_order.body).to match_snapshot_auto
    end

    it 'without chapter outline' do
      described_class.v2(book: book_with_diff_order)
      expect(book_with_diff_order.body).to match_snapshot_auto
    end
  end

  context 'when v2 is called on a book without chapter-objectives' do
    it 'works' do
      described_class.v2(
        book: book_with_intro_objectives, options: { strategy: :none, introduction_order: :v2 }
      )
      expect(book_with_intro_objectives.body).to match_snapshot_auto
    end

    it 'unknown strategy raises' do
      expect {
        described_class.v2(book: book_with_intro_objectives, options: { strategy: :hello })
      }.to raise_error('No such strategy')
    end
  end

  context 'when v2 called on book with unit opener' do
    it 'bakes' do
      described_class.v2(
        book: book_with_unit_opener,
        options: { strategy: :default, bake_chapter_outline: true, introduction_order: :v3 }
      )
      expect(book_with_unit_opener.body).to match_snapshot_auto
    end
  end

  context 'when v2 is called with strategy: add_objectives' do
    it 'works' do
      described_class.v2(
        book: book_v1, options: {
          strategy: :add_objectives,
          bake_chapter_outline: true,
          introduction_order: :v1
        }
      )
      expect(book_v1.body).to match_snapshot_auto
    end
  end

  context 'when book has added targt labels for introduction pages and does not use gramatical cases' do
    it 'stores link text' do
      pantry = book_v1.pantry(name: :link_text)
      expect(pantry).to receive(:store).with('Chapter 1 Chapter 1 Title', { label: 'ipId' })
      expect(pantry).to receive(:store).with('Chapter 2 Chapter 2 Title', { label: 'testid2' })
      described_class.v2(book: book_v1, options: {
        strategy: :add_objectives,
        bake_chapter_outline: true,
        introduction_order: :v1
      }
    )
    end
  end

  context 'when book has blocked adding target labels for introduction pages' do
    it 'doesn not stores link text for introduction pages' do
      pantry = book_v1.pantry(name: :link_text)
      expect(pantry).not_to receive(:store).with('Chapter 1 Chapter 1 Title', { label: 'ipId' })
      described_class.v2(book: book_v1, options: {
        strategy: :add_objectives,
        bake_chapter_outline: true,
        introduction_order: :v1,
        block_target_label: true
      }
    )
    end
  end

  context 'when book uses grammatical cases' do
    it 'stores link text' do
      with_locale(:pl) do
        stub_locales({
          'chapter': {
            'nominative': 'Rozdział',
            'genitive': 'Rozdziału'
          }
        })

        pantry = book_v1.pantry(name: :nominative_link_text)
        expect(pantry).to receive(:store).with('Rozdział 1 Chapter 1 Title', { label: 'ipId' })
        expect(pantry).to receive(:store).with('Rozdział 2 Chapter 2 Title', { label: 'testid2' })

        pantry = book_v1.pantry(name: :genitive_link_text)
        expect(pantry).to receive(:store).with('Rozdziału 1 Chapter 1 Title', { label: 'ipId' })
        expect(pantry).to receive(:store).with('Rozdziału 2 Chapter 2 Title', { label: 'testid2' })

        described_class.v2(book: book_v1, options: {
          strategy: :add_objectives,
          bake_chapter_outline: true,
          introduction_order: :v1,
          cases: true
          })
      end
    end
  end
end
