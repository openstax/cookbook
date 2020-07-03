@solution_1 = Kitchen::Recipe.new do |doc|

  div = doc.search("div").first
  div.name = "h1"
  div.replace_children(with: "<span>World!</span>")

end
