# frozen_string_literal: true

module Kitchen::Directions::BakeFootnotes
  class V1

    def bake(book:, number_format: :arabic)
      # Footnotes are numbered either within their top-level pages (preface,
      # appendices, etc) or within chapters. Tackle each case separately

      book.body.element_children.only(Kitchen::PageElement,
                                      Kitchen::CompositePageElement,
                                      Kitchen::CompositeChapterElement).each do |page|
        bake_footnotes_within(page, number_format: number_format)
      end

      book.chapters.each do |chapter|
        bake_footnotes_within(chapter, number_format: number_format)
      end
    end

    def bake_footnotes_within(container, number_format:)
      footnote_count = 0
      aside_id_to_footnote_number = {}

      container.search("a[role='doc-noteref']").each do |anchor|
        footnote_count += 1
        footnote_number = footnote_count.to_format(number_format)
        anchor.replace_children(with: footnote_number)
        aside_id = anchor[:href][1..-1]
        aside_id_to_footnote_number[aside_id] = footnote_number
        if anchor.parent.name == 'p'
          anchor.parent.add_class('has-noteref')
        elsif anchor.parent.name == 'em' && anchor.parent.parent.name == 'p'
          anchor.parent.parent.add_class('has-noteref')
        end
      end

      container.search('aside').each do |aside|
        footnote_number = aside_id_to_footnote_number[aside.id]
        aside.prepend(child: "<div data-type='footnote-number'>#{footnote_number}</div>")
      end

      footnote_count
    end
  end
end
