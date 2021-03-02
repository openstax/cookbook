# frozen_string_literal: true

@solution2 = Kitchen::Recipe.new do |doc|

  doc.search('div').first.name = 'h1'
  doc.search('span').first.replace_children(with: 'World!')

end
