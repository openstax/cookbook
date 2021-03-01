# frozen_string_literal: true
@solution_1 = Kitchen::Recipe.new do |doc|

  doc.search("[data-type='chapter']").each do |chapter|
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
