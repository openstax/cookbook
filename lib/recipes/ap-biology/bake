#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../recipes_helper'

recipe = Kitchen::BookRecipe.new(book_short_name: :ap_bio) do |doc, _resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  BakeUnnumberedFigure.v1(book: book)
  AddInjectedExerciseId.v1(book: book)
  book.injected_exercises.each do |exercise|
    BakeInjectedExercise.v1(exercise: exercise)
  end

  BakePreface.v1(book: book)
  BakeUnitTitle.v1(book: book)
  BakeChapterTitle.v1(book: book)
  BakeChapterIntroductions.v1(book: book)

  BakeAutotitledNotes.v1(
    book: book,
    classes: %w[visual-connection
                ost-sciprac-scithink],
    options: { bake_subtitle: false }
  )
  BakeAutotitledNotes.v1(
    book: book,
    classes: %w[interactive
                ost-sciprac-activity
                ap-science-practices
                os-teacher
                evolution
                ap-everyday
                career
                everyday
                experiment
                scientific]
  )
  BakeUnclassifiedNotes.v1(book: book)

  book.exercises('$.unnumbered').each do |exercise|
    exercise.problem.wrap_children(class: 'os-problem-container')
  end
  # Injected questions in notes should be treated as unnumbered questions
  book.notes.injected_questions.each do |question|
    question.wrap_children(class: 'os-problem-container')
  end

  book.chapters.each do |chapter|
    chapter.search('div[data-type="abstract"]').each(&:trash)
    BakeNonIntroductionPages.v1(chapter: chapter)

    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata)
    BakeChapterSummary.v1(chapter: chapter, metadata_source: metadata)

    custom_sections = %w[review critical-thinking ap-test-prep science-practice]
    custom_sections.each do |section_key|
      MoveCustomSectionToEocContainer.v1(
        chapter: chapter,
        metadata_source: metadata,
        container_key: section_key,
        uuid_key: ".#{section_key}",
        section_selector: "section.#{section_key}"
      ) do |section|
        RemoveSectionTitle.v1(section: section)
      end
    end

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}")
    end

    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}")
    end

    # Bake both kinds of exercise
    BakeAllNumberedExerciseTypes.v1(
      within: chapter.search('div.os-eoc'),
      exercise_options: { suppress_solution_if: true }
    )
  end

  book.pages('$.appendix').each do |page|
    appendix_letter = [*('A'..'Z')][page.count_in(:book) - 1]
    BakeAppendix.v1(page: page, number: appendix_letter)

    page.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{appendix_letter}#{figure.count_in(:page)}")
    end
    page.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{appendix_letter}#{table.count_in(:page)}")
    end
  end

  BakeIframes.v1(book: book)
  BakeMathInParagraph.v1(book: book)
  BakeUnnumberedTables.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeLinks.v1(book: book)
end

opts = Slop.parse do |slop|
  slop.string '--input', 'Assembled XHTML input file', required: true
  slop.string '--output', 'Baked XHTML output file', required: true
  slop.string '--resources', 'Path to book resources directory', required: false
end

puts Kitchen::Oven.bake(
  input_file: opts[:input],
  recipes: [recipe, VALIDATE_OUTPUT],
  output_file: opts[:output],
  resource_dir: opts[:resources] || nil
)
