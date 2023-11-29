# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::CompositePageElement do

  let(:metadata) do
    <<~HTML
      <div data-type="metadata" style="display: none;">
        <h1 data-type="document-title" itemprop="name">Metadata title</h1>
      </div>
    HTML
  end

  let(:composite_page1) do
    book_containing(html:
      <<~HTML
        <div data-type="composite-page">
          #{metadata}
          <h2 data-type="document-title">Key Terms</h2>
        </div>
      HTML
      ).composite_pages.first
  end

  describe '#title' do
    context 'with no metadata' do
      let(:metadata) { '' }

      it 'finds the title' do
        expect(composite_page1.title.text).to eq 'Key Terms'
      end
    end

    context 'with metadata' do
      it 'skips metadata to find title' do
        expect(composite_page1.title.text).to eq 'Key Terms'
      end

      it 'errors when no title' do
        composite_page1.title.trash
        expect { composite_page1.title }.to raise_error(/Title not found for composite page/)
      end
    end
  end

  it 'returns the metadata' do
    expect(composite_page1.metadata).to match_normalized_html(metadata)
  end
end
