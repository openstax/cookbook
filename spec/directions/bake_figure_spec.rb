# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeFigure do

  let(:figure_classes) { '' }
  let(:figure_caption) { '<figcaption>Solid <em>carbon</em> dioxide sublimes ...</figcaption>' }

  let(:book_1) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <figure id="someId" class="#{figure_classes}">
            #{figure_caption}
            <span data-type="media" id="otherId" data-alt="This figure shows pieces of a ...">
              <img src="blah.jpg" data-media-type="image/jpeg" alt="This figure shows ..." id="id3" />
            </span>
          </figure>
        HTML
      )
    )
  end

  let(:book_1_figure) { book_1.chapters.figures.first }

  context 'v1' do
    it 'works' do
      expect(book_1.document.pantry(name: :link_text)).to receive(:store).with('Figure 1.2', label: 'someId')

      described_class.v1(figure: book_1_figure, number: '1.2')

      expect(book_1.search('.os-figure').first).to match_html_nodes(
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
        described_class.v1(figure: book_1_figure, number: '1.2')
        expect(book_1.search('.os-caption').first).to be nil
      end
    end

    context 'figure has splash class' do
      let(:figure_classes) { 'splash' }

      it "gets a 'has-splash' class" do
        described_class.v1(figure: book_1_figure, number: '1.2')
        expect(book_1.search('.os-figure').first.has_class?('has-splash')).to be true
      end
    end

    context 'figure does not have splash class' do
      it "does not get a 'has-splash' class" do
        described_class.v1(figure: book_1_figure, number: '1.2')
        expect(book_1.search('.os-figure').first.has_class?('has-splash')).to be false
      end
    end
  end

end
