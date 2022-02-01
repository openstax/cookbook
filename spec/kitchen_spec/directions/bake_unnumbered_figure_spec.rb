# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeUnnumberedFigure do

  let(:book_with_unnumbered_figure) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <figure id="someId" class="unnumbered">
            <span>
              <img src="img.jpg"/>
            </span>
          </figure>
        HTML
      )
    )
  end

  let(:book_with_unnumbered_figure_with_splash) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <figure id="someId" class="unnumbered splash">
            <figcaption>figure caption</figcaption>
            <span>
              <img src="img.jpg"/>
            </span>
          </figure>
        HTML
      )
    )
  end

  let(:book_with_unnumbered_figure_with_caption) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <figure id="someId" class="unnumbered">
            <figcaption>figure caption</figcaption>
            <span>
              <img src="img.jpg"/>
            </span>
          </figure>
        HTML
      )
    )
  end

  let(:book_with_unnumbered_figure_with_title) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <figure id="someId" class="unnumbered">
          <div data-type="title" id="someId">Title</div>
          <span>
            <img src="img.jpg"/>
          </span>
          </figure>
        HTML
      )
    )
  end

  let(:book_with_unnumbered_figure_with_title_and_caption) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <figure id="someId" class="unnumbered">
          <div data-type="title" id="someId">Title</div>
          <figcaption>figure caption</figcaption>
          <span>
            <img src="img.jpg"/>
          </span>
          </figure>
        HTML
      )
    )
  end

  context 'when figure is unnumbered without splash class' do
    it 'does not change the original figure' do
      described_class.v1(book: book_with_unnumbered_figure)
      expect(book_with_unnumbered_figure.pages.first).to match_normalized_html(
        <<~HTML
          <div data-type="page">
            <figure class="unnumbered" id="someId">
              <span>
                <img src="img.jpg" />
              </span>
            </figure>
          </div>
        HTML
      )
    end
  end

  context 'when figure is unnumbered but also a splash' do
    it 'bakes' do
      described_class.v1(book: book_with_unnumbered_figure_with_splash)
      expect(book_with_unnumbered_figure_with_splash.pages.first).to match_normalized_html(
        <<~HTML
          <div data-type="page">
            <div class="os-figure has-splash">
              <figure class="unnumbered splash" id="someId">
                <span>
                  <img src="img.jpg" />
                </span>
              </figure>
              <div class="os-caption-container">
                <span class="os-caption">figure caption</span>
              </div>
            </div>
          </div>
        HTML
      )
    end
  end

  context 'when figure is unnumbered but has caption' do
    it 'bakes' do
      described_class.v1(book: book_with_unnumbered_figure_with_caption)
      expect(book_with_unnumbered_figure_with_caption.pages.first).to match_normalized_html(
        <<~HTML
          <div data-type="page">
            <div class="os-figure">
              <figure class="unnumbered" id="someId">
                <span>
                  <img src="img.jpg" />
                </span>
              </figure>
              <div class="os-caption-container">
                <span class="os-caption">figure caption</span>
              </div>
            </div>
          </div>
        HTML
      )
    end
  end

  context 'when figure is unnumbered but has title' do
    it 'bakes' do
      described_class.v1(book: book_with_unnumbered_figure_with_title)
      expect(book_with_unnumbered_figure_with_title.pages.first).to match_normalized_html(
        <<~HTML
          <div data-type="page">
            <div class="os-figure">
              <figure class="unnumbered" id="someId">
                <span>
                  <img src="img.jpg" />
                </span>
              </figure>
              <div class="os-caption-container">
              <span class="os-title" data-type="title" id="someId">Title</span>
              </div>
            </div>
          </div>
        HTML
      )
    end
  end

  context 'when figure is unnumbered but has caption & title' do
    it 'bakes' do
      described_class.v1(book: book_with_unnumbered_figure_with_title_and_caption)
      expect(book_with_unnumbered_figure_with_title_and_caption.pages.first).to match_normalized_html(
        <<~HTML
          <div data-type="page">
            <div class="os-figure">
              <figure class="unnumbered" id="someId">
                <span>
                  <img src="img.jpg" />
                </span>
              </figure>
              <div class="os-caption-container">
                <span class="os-title" data-type="title" id="someId">Title</div>
                <span class="os-divider"> </span>
                <span class="os-caption">figure caption</span>
              </div>
            </div>
          </div>
        HTML
      )
    end
  end
end
