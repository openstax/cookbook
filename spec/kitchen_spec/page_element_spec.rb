# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::PageElement do

  let(:metadata) do
    <<~HTML
      <div data-type="metadata" style="display: none;">
        <h1 data-type="document-title" itemprop="name">Metadata title</h1>
      </div>
    HTML
  end

  let(:page1) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          #{metadata}
          <div data-type="document-title">Page title</div>
        HTML
      )).pages.first
  end

  let(:page_with_multiple_titles) do
    book_containing(html:
      <<~HTML
        <div data-type="page" id="testidOne">
          <div data-type="document-title">Title</div>
          <div data-type="metadata">
            <div data-type="document-title">Title MetaData</div>
          </div>
        </div>
      HTML
    ).pages.first!
  end

  let(:introduction_page) do
    <<~HTML
      <div class="introduction" data-type="page">
        <span>stuff</span>
      </div>
    HTML
  end

  let(:sample_chapter) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <h1 data-type="document-title">Chapter 1 Title</h1>
          #{introduction_page}
          <div data-type="page" class="foo">
            <div data-type="document-title">section 1</div>
          </div>
          <div data-type="page" class="foo">
            <div data-type="document-title">section 2</div>
          </div>
        </div>
      HTML
    ).chapters.first
  end

  describe '#title' do
    context 'with no metadata' do
      let(:metadata) { '' }

      it 'finds the title' do
        expect(page1.title.text).to eq 'Page title'
      end
    end

    context 'with metadata' do
      it 'skips metadata to find title' do
        expect(page1.title.text).to eq 'Page title'
      end

      it 'errors when no title' do
        page1.title.trash
        expect { page1.title }.to raise_error(/Title not found for page/)
      end
    end
  end

  describe '#count_in_chapter_without_intro_page' do
    context 'with an intro page' do
      it 'breaks when asked to count an introduction page' do
        expect { sample_chapter.introduction_page.count_in_chapter_without_intro_page }.to raise_error('Introduction pages cannot be counted with this method')
      end

      it 'numbers each page correctly' do
        count = sample_chapter.pages.map { |page| page.count_in_chapter_without_intro_page unless page.is_introduction? }
        expect(count).to eq([nil, 1, 2])
      end
    end

    context 'with no intro page' do
      let(:introduction_page) { '' }

      it 'numbers each page correctly' do
        count = sample_chapter.pages.map { |page| page.count_in_chapter_without_intro_page }
        expect(count).to eq([1, 2])
      end
    end
  end

  describe '#titles' do
    it 'returns all titles in element' do
      expect(page_with_multiple_titles.titles.map(&:to_s)).to match([/Title/, /Title MetaData/])
    end
  end

  it 'returns the metadata' do
    expect(page1.metadata).to match_normalized_html(metadata)
  end
end
