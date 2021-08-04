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
      expect(book).to match_normalized_html(
        <<~HTML
          <html xmlns:m="http://www.w3.org/1998/Math/MathML"
            data-pdf-folio-preface-message="Preface"
            data-pdf-folio-access-message="Access for free at openstax.org">
            <body>
              <div class="hi">Howdy</div>
            </body>
          </html>
        HTML
      )
    end

    it 'works in spanish' do
      with_locale(:es) do
        described_class.v1(book: book)
      end

      expect(book).to match_normalized_html(
        <<~HTML
          <html xmlns:m="http://www.w3.org/1998/Math/MathML"
            data-pdf-folio-preface-message="Prefacio"
            data-pdf-folio-access-message="Acceso gratis en openstax.org">
            <body>
              <div class="hi">Howdy</div>
            </body>
          </html>
        HTML
      )
    end
  end
end
