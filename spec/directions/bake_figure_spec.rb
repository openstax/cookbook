# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeFigure do

  before do
    stub_locales({
      'figure': 'Figure'
    })
  end

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

  let(:book_with_problematic_figures) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <figure id="fig1" class="unnumbered splash">
          </figure>
          <figure id="fig2" class="splash">
          </figure>
          <figure id="fig3" class="unnumbered">
          </figure>
          <figure id="fig4">
            <figure id="fig5">
            </figure>
          </figure>
        HTML
      )
    )
  end

  let(:book1_figure) { book1.chapters.figures.first }

  describe 'v1' do
    it 'works' do
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

    context 'when book does not use grammatical cases' do
      it 'stores link text' do
        pantry = book1.pantry(name: :link_text)
        expect(pantry).to receive(:store).with('Figure 1.2', { label: 'someId' })
        described_class.v1(figure: book1_figure, number: '1.2')
      end
    end

    context 'when book uses grammatical cases' do
      it 'stores link text' do
        with_locale(:pl) do
          stub_locales({
            'figure': {
              'nominative': 'Rysunek',
              'genitive': 'Rysunku'
            }
          })

          pantry = book1.pantry(name: :nominative_link_text)
          expect(pantry).to receive(:store).with('Rysunek 1.2', { label: 'someId' })

          pantry = book1.pantry(name: :genitive_link_text)
          expect(pantry).to receive(:store).with('Rysunku 1.2', { label: 'someId' })
          described_class.v1(figure: book1_figure, number: '1.2', cases: true)
        end
      end
    end
  end

  describe '#subfigure?' do
    it 'can detect subfigures' do
      expect(book2.chapters.figures.map(&:subfigure?)).to eq([false, true, true])
    end
  end

  describe '#figure_to_bake?' do
    it 'can select what figures should be baked' do
      expect(book_with_problematic_figures.figures.map(&:figure_to_bake?)).to eq([true, true, false, true, false])
    end
  end

end
