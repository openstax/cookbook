# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeFigure do

  let(:figure_classes) { '' }
  let(:figure_caption) { '<figcaption>Solid <em>carbon</em> dioxide sublimes ...</figcaption>' }
  let(:figure_title)   { "<div data-type='title'>This Is A Title</div>" }

  let(:book1) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <figure id="someId" class="#{figure_classes}">
            #{figure_caption}
            #{figure_title}
            <span data-type="media" id="otherId" data-alt="This figure shows pieces of a ...">
              <img src="blah.jpg" data-media-type="image/jpeg" alt="This figure shows ..." id="id3" />
            </span>
          </figure>
        HTML
      )
    )
  end

  let(:book2) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <figure id="someId" class="#{figure_classes}">
            #{figure_caption}
            <figure id="otherId" data-alt="This figure shows pieces of a ...">
              <img src="blah.jpg" data-media-type="image/jpeg" alt="This figure shows ..." id="id3" />
            </figure>
            <figure id="otherId" data-alt="This figure shows pieces of a ...">
              <img src="blah.jpg" data-media-type="image/jpeg" alt="This figure shows ..." id="id3" />
            </figure>
          </figure>
        HTML
      )
    )
  end

  let(:book_with_unnumbered_splash) do
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

  let(:book1_figure) { book1.chapters.figures.first }

  describe 'v1' do
    it 'works' do
      expect(book1.pantry(name: :link_text)).to receive(:store).with('Figure 1.2', label: 'someId')

      described_class.v1(figure: book1_figure, number: '1.2')

      expect(book1.search('.os-figure').first).to match_html_nodes(
        <<~HTML
          <div class="os-figure">
            <figure id="someId" class="">
              <span data-type="media" id="otherId" data-alt="This figure shows pieces of a ...">
                <img src="blah.jpg" data-media-type="image/jpeg" alt="This figure shows ..." id="id3" />
              </span>
            </figure>
            <div class="os-caption-container">
              <span class="os-title-label">Figure </span>
              <span class="os-number">1.2</span>
              <span class="os-divider"> </span>
              <span class="os-title" data-type="title" id="">This Is A Title</span>
              <span class="os-divider"> </span>
              <span class="os-caption">Solid <em>carbon</em> dioxide sublimes ...</span>
            </div>
          </div>
        HTML
      )
    end

    context 'without a caption' do
      let(:figure_caption) { '' }

      it 'works without a caption' do
        described_class.v1(figure: book1_figure, number: '1.2')
        expect(book1.search('.os-caption').first).to be nil
      end
    end

    context 'without a title' do
      let(:figure_title) { '' }

      it 'works without a title' do
        described_class.v1(figure: book1_figure, number: '1.2')
        expect(book1.search('.os-title').first).to be nil
      end
    end

    context 'when figure has splash class' do
      let(:figure_classes) { 'splash' }

      it "gets a 'has-splash' class" do
        described_class.v1(figure: book1_figure, number: '1.2')
        expect(book1.search('.os-figure').first.has_class?('has-splash')).to be true
      end
    end

    context 'when figure does not have splash class' do
      it "does not get a 'has-splash' class" do
        described_class.v1(figure: book1_figure, number: '1.2')
        expect(book1.search('.os-figure').first.has_class?('has-splash')).to be false
      end
    end

    context 'when figure is unnumbered but also a splash' do
      it 'bakes' do
        described_class.v1(figure: book_with_unnumbered_splash.figures.first, number: 'blah')
        expect(book_with_unnumbered_splash.pages.first).to match_normalized_html(
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
  end

  describe '#subfigure?' do
    it 'can detect subfigures' do
      expect(book2.chapters.figures.map(&:subfigure?)).to eq([false, true, true])
    end
  end

end
