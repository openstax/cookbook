# frozen_string_literal: true
module Kitchen::Directions::BakeFootnotes
  class V1

    def bake(book:)
      # Footnotes are numbered either within their top-level pages (preface,
      # appendices, etc) or within chapters. Tackle each case separately

      book.body.element_children.only(Kitchen::PageElement,
                                      Kitchen::CompositePageElement).each do |page|
        bake_footnotes_within(page)
      end

      book.chapters.each do |chapter|
        bake_footnotes_within(chapter)
      end
    end

    def bake_footnotes_within(container)
      footnote_number = 0
      aside_id_to_footnote_number = {}

      container.search("a[role='doc-noteref']").each do |anchor|
        footnote_number += 1
        anchor.replace_children(with: footnote_number.to_s)
        aside_id = anchor[:href][1..-1]
        aside_id_to_footnote_number[aside_id] = footnote_number
      end

      container.search('aside').each do |aside|
        footnote_number = aside_id_to_footnote_number[aside.id]
        aside.prepend(child: "<div data-type='footnote-number'>#{footnote_number}</div>")
      end
    end

  end
end
