# frozen_string_literal: true
@solution_1 = Kitchen::Recipe.new do |doc|

  div = doc.search('div').first
  div.name = 'h1'
  div.search('span').first.replace_children(with: 'World!')

end
