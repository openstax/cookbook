# frozen_string_literal: true

PRECALCULUS_COREQ_RECIPE = Kitchen::BookRecipe.new(book_short_name: :precalculus_coreq) do |doc|
  include Kitchen::Directions

  book = doc.book

  book.chapters.pages.search('section.practice-perfect').exercises.each do |exercise|
    exercise.remove_class('material-set-2')
    exercise.add_class('os-coreq-exercises')
    BakeNumberedExercise.v1(exercise: exercise, number: exercise.count_in(:page))
    BakeFirstElements.v1(within: exercise)
    exercise.search('table').each do |table|
      table.add_class('os-coreq-element')
    end
  end

  book.pages.search('section.coreq-skills').each do |coreq_section|
    coreq_section.prepend(child:
      <<~HTML
        <h3 class="os-title">
          <span class="os-title-label">#{I18n.t(:'coreq-skills')}</span>
        </h3>
      HTML
    )
    coreq_section.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v2(table: table, number: table.count_in(:page))
    end
    coreq_section.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure, number: figure.count_in(:page))
    end
    coreq_section.examples.each do |example|
      BakeExample.v1(example: example, number: example.count_in(:page), title_tag: 'h3')
    end
  end
end
