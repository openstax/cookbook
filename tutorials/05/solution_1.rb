# frozen_string_literal: true
@solution_1 = Kitchen::Recipe.new do |doc|
  original = doc.search('#original').first
  original.append(sibling: <<~HTML
    \n#{original.copy.paste}
  HTML
  )

  doc.search('#badness').trash
end
