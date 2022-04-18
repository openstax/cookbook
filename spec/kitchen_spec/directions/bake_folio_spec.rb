# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeFolio do
  let(:book) do
    book_containing(html:
      <<~HTML
        <div class='hi'>Howdy</div>
      HTML
    )
  end

  describe 'folio pdf translations' do
    it 'works in english' do
      described_class.v1(book: book)
      expect(book).to match_snapshot_auto
    end

    it 'works in spanish' do
      with_locale(:es) do
        described_class.v1(book: book)
      end

      expect(book).to match_snapshot_auto
    end
  end
end
