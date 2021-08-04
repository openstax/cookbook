# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeFolio
      def self.v1(book:)
        book['data-pdf-folio-preface-message'] = I18n.t(:"folio.preface")
        book['data-pdf-folio-access-message'] = I18n.t(:"folio.access_for_free")
      end
    end
  end
end
