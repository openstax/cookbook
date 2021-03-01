# frozen_string_literal: true
@solution_1 = Kitchen::BookRecipe.new do |doc|
  book = doc.book

  book.tables.each do |table|
    table_name = "Table #{table.count_in(:book)}"
    table.prepend(child: "<div class='caption'>#{table_name}</div>")
    doc.pantry(name: :link_text).store table_name, label: table.id
  end

  book.figures.each do |figure|
    figure_name = "Figure #{figure.count_in(:book)}"
    figure.prepend(child: "<div class='caption'>#{figure_name}</div>")
    doc.pantry(name: :link_text).store figure_name, label: figure.id
  end

  book.search('a.needs-label').each do |anchor|
    id = anchor[:href][1..-1]
    anchor.replace_children(with: doc.pantry(name: :link_text).get(id))
  end
end
