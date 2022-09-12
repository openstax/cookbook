# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeChapterSummary do

  before do
    stub_locales({
      'eoc_summary_title': 'Summary',
      'eoc_exercises_title': 'Exercises',
      'eoc': {
        'summary': 'Summary',
        'section-summary': 'Summary'
      }
    })
  end

  let(:chapter) do
    chapter_element(
      <<~HTML
        <div data-type='page' id="00" class="introduction">
          <h1 data-type="document-title" itemprop="name" id="intro">Introduction page!</h1>
          <section class="summary" data-element-type="section-summary">
              <h3 data-type='title'>Kitchen Prep</h3>
              <p>This moves too!</p>
          </section>
        </div>
        <div data-type='page' id ="01">
          <h1 data-type="document-title" itemprop="name" id="first">First Title</h1>
          <section class="summary" data-element-type="section-summary">
              <h3 data-type='title'>Roasting</h3>
              <p>Many paragraphs provide a good summary.</p>
          </section>
        </div>
        <div data-type='page' id="02">
          <h1 data-type="document-title" itemprop="name" id="second">Second Title</h1>
          <section class="summary" data-element-type="section-summary">
              <h3 data-type='title'>Frying</h3>
              <p>Ooh, it's another bit of text.</p>
          </section>
        </div>
      HTML
    )
  end

  let(:chapter_with_modules_title_children) do
    chapter_element(
      <<~HTML
        <div data-type='page' id="00" class="introduction">
          <h1 data-type="document-title" itemprop="name" id="intro"><em data-effect="italics">Italics</em> & not italics with <sub>subscript</sub> and <sup>superscript</sup> text Introduction page!</h1>
          <section class="summary" data-element-type="section-summary">
              <h3 data-type='title'>Kitchen Prep</h3>
              <p>This moves too!</p>
          </section>
        </div>
        <div data-type='page' id ="01">
          <h1 data-type="document-title" itemprop="name" id="first"><em data-effect="italics">Italics</em> & not italics with <sub>subscript</sub> and <sup>superscript</sup> text First Title</h1>
          <section class="summary" data-element-type="section-summary">
              <h3 data-type='title'>Roasting</h3>
              <p>Many paragraphs provide a good summary.</p>
          </section>
        </div>
        <div data-type='page' id="02">
          <h1 data-type="document-title" itemprop="name" id="second"><em data-effect="italics">Italics</em> & not italics with <sub>subscript</sub> and <sup>superscript</sup> text Second Title</h1>
          <section class="summary" data-element-type="section-summary">
              <h3 data-type='title'>Frying</h3>
              <p>Ooh, it's another bit of text.</p>
          </section>
        </div>
      HTML
    )
  end

  let(:chapter_summary_no_bake_title) do
    chapter_element(
      page_element(
        <<~HTML
          <h1 data-type="document-title" itemprop="name" id="intro">Introduction page!</h1>
          <section class="summary" data-element-type="section-summary">
            <h3 data-type="document-title">
              <span class="os-number">Do not bake number</span>
              <span class="os-divider"> </span>
              <span class="os-text" data-type="" itemprop="">No Bake Title</span>
            </h3>
            <p>This should stay where it is.</p>
          </section>
        HTML
      )
    )
  end

  let(:append_to) do
    new_element(
      <<~HTML
        <div class="os-eoc os-chapter-review-container" data-type="composite-chapter" data-uuid-key=".chapter-review">
          <h2 data-type="document-title" id="composite-chapter-1">
            <span class="os-text">foo</span>
          </h2>
          <div data-type="metadata" style="display: none;">
            <h1 data-type="document-title" itemprop="name">foo</h1>
            <div>metadata</div>
          </div>
        </div>
      HTML
    )
  end

  context 'when v1 is called on a chapter' do
    context 'when klass value is set to "section-summary" in book recipe bake file' do
      it 'works' do
        metadata = metadata_element.append(child:
          <<~HTML
            <div data-type="random" id="subject">Random - should not be included</div>
          HTML
        )
        described_class.v1(chapter: chapter, metadata_source: metadata, klass: 'section-summary')
        expect(
          chapter
        ).to match_snapshot_auto
      end
    end

    context 'when klass has default value' do
      it 'works' do
        metadata = metadata_element.append(child:
          <<~HTML
            <div data-type="random" id="subject">Random - should not be included</div>
          HTML
        )
        described_class.v1(chapter: chapter, metadata_source: metadata)
        expect(
          chapter
        ).to match_snapshot_auto
      end
    end
  end

  it 'does not bake a chapter summary title that already includes the number and divider' do
    metadata = metadata_element.append(child:
      <<~HTML
        <div data-type="random" id="subject">Random - should not be included</div>
      HTML
    )
    described_class.v1(chapter: chapter_summary_no_bake_title, metadata_source: metadata, klass: 'section-summary')
    expect(
      chapter_summary_no_bake_title
    ).to match_snapshot_auto
  end

  context 'when v1 is called on a composite chapter' do
    it 'works' do
      metadata = metadata_element.append(child:
        <<~HTML
          <div data-type="random" id="subject">Random - should not be included</div>
        HTML
      )
      expect(
        described_class.v1(chapter: chapter_summary_no_bake_title, metadata_source: metadata, klass: 'section-summary', append_to: append_to)
      ).to match_snapshot_auto
    end
  end

  context 'when chapter includes modules titles children' do
    it 'keeps the modules titles children' do
      metadata = metadata_element.append(child:
        <<~HTML
          <div data-type="random" id="subject">Random - should not be included</div>
        HTML
      )
      described_class.v1(chapter: chapter_with_modules_title_children, metadata_source: metadata)
      expect(
        chapter_with_modules_title_children
      ).to match_snapshot_auto
    end
  end
end
