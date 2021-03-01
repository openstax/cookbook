# frozen_string_literal: true

@solution_2 = Kitchen::BookRecipe.new do |doc|
  book = doc.book

  # Solution 1 treats figures and tables almost identically and ends up duplicating
  # a lot of code.  To DRY up that code, pull out the parts that change (the search
  # enumerator and the label):

  enumerators_to_labels_map = {
    book.tables => 'Table',
    book.figures => 'Figure'
  }

  enumerators_to_labels_map.each do |enumerator, label|
    enumerator.each do |element|
      name = "#{label} #{element.count_in(:book)}"
      element.prepend(child: "<div class='caption'>#{name}</div>")
      doc.pantry(name: :link_text).store name, label: element.id
    end
  end

  book.search('a.needs-label').each do |anchor|
    id = anchor[:href][1..-1]
    anchor.replace_children(with: doc.pantry(name: :link_text).get(id))
  end
end
