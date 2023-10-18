# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakePreface::V1 do

  before do
    stub_locales({
      'figure': 'Figure'
    })
  end

  let(:book1) do
    book_containing(html:
      <<~HTML
        <div data-type="page" class="preface">
          <div data-type="document-title">Preface</div>
          <div data-type="metadata">
            <div data-type="document-title">Preface</div>
          </div>
        </div>
        <div data-type="page" class="preface">
          <div data-type="document-title">Preface</div>
          <div class="description" data-type="description" itemprop="description">description</div>
          <div data-type="metadata">
            <div data-type="document-title">Preface</div>
          </div>
          <figure id="someId">
            <figcaption>Solid <em>carbon</em> dioxide sublimes ...</figcaption>
            <div data-type='title'>This Is A Title</div>
            <span data-type="media" id="otherId" data-alt="This figure shows pieces of a ...">
            </span>
          </figure>
          <div data-type="abstract" id="abcde">abstract</div>
        </div>

        <div data-type="page" class="preface">
          <div data-type="document-title">Preface</div>
          <div class="description" data-type="description" itemprop="description">description</div>
          <div data-type="metadata">
            <div data-type="document-title">Preface</div>
          </div>
          <figure id="someId1">
            <figcaption>Solid <em>carbon</em> dioxide sublimes ...</figcaption>
            <div data-type='title'>This Is A Title</div>
            <span data-type="media" id="otherId" data-alt="This figure shows pieces of a ...">
            </span>
          </figure>
          <figure id="someId2">
          <figcaption>Solid <em>carbon</em> dioxide sublimes ...</figcaption>
          <div data-type='title'>This Is A Title</div>
          <span data-type="media" id="otherId" data-alt="This figure shows pieces of a ...">
          </span>
        </figure>
          <div data-type="abstract" id="abcde">abstract</div>
        </div>
      HTML
    )
  end

  let(:book2) do
    book_containing(html:
      <<~HTML
        <div data-type="page" class="preface">
          <div data-type="document-title">Preface</div>
          <div class="description" data-type="description" itemprop="description">description</div>
          <div data-type="metadata">
            <div data-type="document-title">Preface</div>
          </div>
          <figure id="someId">
            <figcaption>Solid <em>carbon</em> dioxide sublimes ...</figcaption>
            <div data-type='title'>This Is A Title</div>
            <span data-type="media" id="otherId" data-alt="This figure shows pieces of a ...">
            </span>
          </figure>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.new.bake(book: book1, title_element: 'h1')
    expect(book1).to match_snapshot_auto
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

        pantry = book2.pantry(name: :nominative_link_text)
        expect(pantry).to receive(:store).with('Rysunek 1', { label: 'someId' })

        pantry = book2.pantry(name: :genitive_link_text)
        expect(pantry).to receive(:store).with('Rysunku 1', { label: 'someId' })
        described_class.new.bake(book: book2, title_element: 'h1', cases: true)
      end
    end
  end
end
