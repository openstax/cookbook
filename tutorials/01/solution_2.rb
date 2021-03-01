# frozen_string_literal: true

@solution_2 = Kitchen::BookRecipe.new do |doc|

  #                       ^
  #                       |
  #
  # BookRecipe gives us `doc.book` and `book.chapters` to make the code cleaner
  #
  #    |       |
  #    v       v

  doc.book.chapters.each do |chapter|
    movers = chapter.search('.will-move').cut
    movers.each { |mover| mover.name = 'section' }

    chapter.append(child: <<~HTML
      <div class="eoc">
        <div class="os-title">End of Chapter Collations</div>
        #{movers.paste}
      </div>
    HTML
    )
  end

end
