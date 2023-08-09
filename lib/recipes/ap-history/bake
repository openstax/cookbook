#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../recipes_helper'

recipe = Kitchen::BookRecipe.new(book_short_name: :ap_history) do |doc, _resources|
  include Kitchen::Directions

  book = doc.book

  book.search('cnx-pi').trash

  BakeUnnumberedFigure.v1(book: book)
  BakePreface.v1(book: book)
  BakeUnitTitle.v1(book: book)
  BakeChapterTitle.v1(book: book)
  BakeAutotitledNotes.v1(book: book, classes: %w[os-teacher])
  BakeUnclassifiedNotes.v1(book: book)
  BakeIframes.v1(book: book)
  BakeAccessibilityFixes.v1(section: book)

  book.chapters.each do |chapter|
    BakeNonIntroductionPages.v1(chapter: chapter)

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}")
    end

    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}")
    end

    # Bake & number exercises in place, within section
    chapter.pages.sections('$[data-depth="2"]').each do |section|
      section.exercises.each do |exercise|
        BakeNumberedExercise.v1(exercise: exercise, number: exercise.count_in(:section))
      end
      section.injected_questions.each do |question|
        BakeInjectedExerciseQuestion.v1(question: question, number: question.count_in(:section))
      end
    end
  end

  book.pages('$.appendix').each do |page|
    appendix_letter = [*('A'..'Z')][page.count_in(:book) - 1]
    BakeAppendix.v1(page: page, number: appendix_letter)
    page.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{appendix_letter}#{figure.count_in(:page)}")
    end
  end

  BakeUnnumberedTables.v1(book: book)

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
