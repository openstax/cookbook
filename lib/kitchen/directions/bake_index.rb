module Kitchen
  module Directions
    module BakeIndex

      def self.v1(book:)
        metadata_elements = book.metadata.search(%w(.authors .publishers .print-style
                                                    .permissions [data-type='subject'])).copy
        index = {}

        book.pages.terms.each do |term|
          # Markup the term
          term.id = "auto_#{term.ancestor(:page).id}_term#{term.count_in(:book)}"
          group_by_letter = term.text[0]
          term['group-by'] = group_by_letter

          # Remember it in our index hash
          page_title = term.ancestor(:page).title

          index[group_by_letter.downcase] ||= []
          index[group_by_letter.downcase].push({
            group_by_letter: group_by_letter,
            term: term.text,
            id: term.id,
            section: page_title.text.gsub(/\n/,'')
          })
        end

        # Sort the index entries within each letter
        index.values.each do |entries_by_letter|
          entries_by_letter.sort_by!{|entry| entry[:term].downcase}
        end

        # Build the HTML for each letter section
        letter_sections = index.keys.sort.map do |letter|
          term_tags = index[letter].map do |entry|
            <<~HTML
              <div class="os-index-item">
                <span class="os-term" group-by="#{entry[:group_by_letter]}">#{entry[:term]}</span>
                <a class="os-term-section-link" href="##{entry[:id]}">
                  <span class="os-term-section">#{entry[:section]}</span>
                </a>
              </div>
            HTML
          end.join("\n")

          <<~HTML
            <div class="group-by">
              <span class="group-label">#{letter.upcase}</span>
              #{term_tags}
            </div>
          HTML
        end.join("\n")

        # Add the index page
        book.first("body").append(child:
          <<~HTML
          <div class="os-eob os-index-container " data-type="composite-page" data-uuid-key="index">
            <h1 data-type="document-title">
              <span class="os-text">#{I18n.t(:eob_index_title)}</span>
            </h1>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">#{I18n.t(:eob_index_title)}</h1>
              #{metadata_elements.paste}
            </div>
            #{letter_sections}
          </div>
          HTML
        )
      end

    end
  end
end
