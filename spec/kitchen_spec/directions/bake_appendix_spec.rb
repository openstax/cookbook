# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeAppendix do
  before do
    stub_locales({
      'appendix': 'Appendix'
    })
  end

  let(:page) do
    page_element(
      <<~HTML
        <div data-type="document-title">Appendix Title</div>
        <section data-depth="1">
          <div data-type="title">hello</div>
          <section data-depth="2">
            <div data-type="title">world</div>
          </section>
        </section>
      HTML
    )
  end

  let(:page_appendix_no_title) do
    page_element(
      <<~HTML
        <div data-type="document-title">Hi</div>
        <section data-depth="1"></section>
      HTML
    )
  end

  let(:page_appendix_with_section_column_container) do
    page_element(
      <<~HTML
        <div data-type="document-title">Appendix Title</div>
        <section data-depth="1" class="column-container">
          <div data-type="title">hello</div>
          <section data-depth="2">
            <div data-type="title">world</div>
          </section>
        </section>
      HTML
    )
  end

  it 'works' do
    described_class.v1(page: page, number: 3)
    expect(page).to match_normalized_html(
      <<~HTML
        <div data-type="page" id="apId">
          <h1 data-type="document-title">
            <span class="os-part-text">Appendix </span>
            <span class="os-number">3</span>
            <span class="os-divider"> </span>
            <span class="os-text" data-type="" itemprop="">Appendix Title</span>
          </h1>
          <section data-depth="1">
            <h2 data-type="title">hello</h2>
            <section data-depth="2">
              <h3 data-type="title">world</h3>
            </section>
          </section>
        </div>
      HTML
    )
  end

  it 'does not explode if title not present in appendix section' do
    described_class.v1(page: page_appendix_no_title, number: 3)
    expect(page_appendix_no_title).to match_normalized_html(
      <<~HTML
        <div data-type="page" id="apId">
          <h1 data-type="document-title">
            <span class="os-part-text">Appendix </span>
            <span class="os-number">3</span>
            <span class="os-divider"> </span>
            <span class="os-text" data-type="" itemprop="">Hi</span>
          </h1>
          <section data-depth="1"></section>
        </div>
      HTML
    )
  end

  it 'bakes section.column-container in appendix page' do
    described_class.v1(page: page_appendix_with_section_column_container, number: 3)
    expect(page_appendix_with_section_column_container).to match_normalized_html(
      <<~HTML
        <div data-type="page" id="apId">
          <h1 data-type="document-title">
            <span class="os-part-text">Appendix </span>
            <span class="os-number">3</span>
            <span class="os-divider"> </span>
            <span class="os-text" data-type="" itemprop="">Appendix Title</span>
          </h1>
          <div data-depth="1" class="column-container">
            <h2 data-type="title">hello</h2>
            <section data-depth="2">
              <h3 data-type="title">world</h3>
            </section>
          </div>
        </div>
      HTML
    )
  end

  context 'when book does not use grammatical cases' do
    it 'stores link text' do
      pantry = page.pantry(name: :link_text)
      expect(pantry).to receive(:store).with('Appendix 3 Appendix Title', { label: 'apId' })
      described_class.v1(page: page, number: '3')
    end
  end

  context 'when book uses grammatical cases' do
    it 'uses nominative case in title' do
      with_locale(:pl) do
        stub_locales({
          'appendix': {
            'nominative': 'Dodatek',
            'genitive': 'Dodatku'
          }
        })

        described_class.v1(page: page, number: 3, cases: true)
        expect(page).to match_normalized_html(
          <<~HTML
            <div data-type="page" id="apId">
              <h1 data-type="document-title">
                <span class="os-part-text">Dodatek </span>
                <span class="os-number">3</span>
                <span class="os-divider"> </span>
                <span class="os-text" data-type="" itemprop="">Appendix Title</span>
              </h1>
              <section data-depth="1">
                <h2 data-type="title">hello</h2>
                <section data-depth="2">
                  <h3 data-type="title">world</h3>
                </section>
              </section>
            </div>
          HTML
        )
      end
    end

    it 'stores link text' do
      with_locale(:pl) do
        stub_locales({
          'appendix': {
            'nominative': 'Dodatek',
            'genitive': 'Dodatku'
          }
        })

        pantry = page.pantry(name: :nominative_link_text)
        expect(pantry).to receive(:store).with('Dodatek 3 Appendix Title', { label: 'apId' })

        pantry = page.pantry(name: :genitive_link_text)
        expect(pantry).to receive(:store).with('Dodatku 3 Appendix Title', { label: 'apId' })
        described_class.v1(page: page, number: '3', cases: true)
      end
    end
  end
end
