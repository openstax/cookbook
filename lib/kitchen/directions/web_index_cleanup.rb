# frozen_string_literal: true

module Kitchen
  module Directions
    module WebIndexCleanup
      # Sometimes one module contains a few the same terms. Each of them has link in index,
      # what causes repetition, because they have the same name (module title).
      # This step has to be done only for webview, because in PDFs links names are pages numbers
      # so even terms are in the same module they could be on different pages.
      # Of course they still could be in the same module and on the same page,
      # but that will be resolved separately in styles.
      def self.v1(book_pages:)
        book_pages.search('.os-index-item').each do |index_item|
          term_links = index_item.search('.os-term-section-link').to_a

          term_links.each_with_index do |_e, i|
            next unless term_links[i + 1]

            if term_links[i].text == term_links[i + 1].text
              term_links[i + 1].previous.trash # remove separator
              term_links[i + 1].trash # remove section link
            end
          end
        end
      end
    end
  end
end
