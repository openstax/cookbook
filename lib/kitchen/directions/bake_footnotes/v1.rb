module Kitchen::Directions::BakeFootnotes
  class V1

    def bake(book:)
      counts_in_parent = Hash.new(0)

      book.search_with(Kitchen::PageElementEnumerator,
                       Kitchen::CompositePageElementEnumerator).each do |page|
        aside_id_to_footnote_number = {}

        page.search("aside").each do |aside|
          footnote_number = counts_in_parent[page.parent.path] += 1
          aside_id_to_footnote_number[aside.id] = footnote_number
          aside.prepend(child: "<div class='footnote-number'>#{footnote_number}</div>")
        end

        page.search("a[role='doc-noteref']").each do |anchor|
          anchor.replace_children(with:
            aside_id_to_footnote_number[anchor[:href][1..-1]].to_s
          )
        end
      end
    end

  end
end
