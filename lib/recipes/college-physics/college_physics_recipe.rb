# frozen_string_literal: true

require_relative '../recipes_helper'

COLLEGE_PHYSICS_RECIPE = Kitchen::BookRecipe.new(
  book_short_name: :college_physics_recipe) do |doc, resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  # BakeImages.v1(book: book, resources: resources)
  BakeUnnumberedFigure.v1(book: book)
  BakePreface.v1(book: book)
  BakeChapterTitle.v1(book: book)
  BakeChapterIntroductions.v1(book: book)

  BakeUnclassifiedNotes.v1(book: book)
  BakeAutotitledNotes.v1(book: book, classes: %w[interactive])
  BakeIframes.v1(book: book)
  BakeMathInParagraph.v1(book: book)

  # Check Your Understanding exercises: titled unnumbered exercises
  book.exercises('$[data-element-type="check-understanding"]').each do |exercise|
    BakeAutotitledExercise.v2(exercise: exercise, title: I18n.t(:'check-understanding'))
  end

  book.chapters.each do |chapter|
    BakeNonIntroductionPages.v1(chapter: chapter)

    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata)
    section_keys = %w[section-summary conceptual-questions problems-exercises]
    section_keys.each do |section_key|
      MoveCustomSectionToEocContainer.v1(
        chapter: chapter,
        metadata_source: metadata,
        container_key: section_key,
        uuid_key: ".#{section_key}",
        section_selector: "section.#{section_key}"
      ) do |section|
        RemoveSectionTitle.v1(section: section)
        title = EocSectionTitleLinkSnippet.v1(page: section.ancestor(:page))
        section.prepend(child: title)
      end
    end

    chapter.sections('$.conceptual-questions').exercises.each do |exercise|
      BakeNumberedExercise.v1(
        exercise: exercise, number: exercise.count_in(:chapter),
        options: { suppress_solution_if: true }
      )
      BakeFirstElements.v1(within: exercise)
    end

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}")
    end
    chapter.examples.each do |example|
      BakeExample.v1(
        example: example,
        number: "#{chapter.count_in(:book)}.#{example.count_in(:chapter)}",
        title_tag: 'h3'
      )
    end
    chapter.tables.each do |table|
      BakeNumberedTable.v1(
        table: table,
        number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}"
      )
    end
  end

  book.pages('$.appendix').each do |page|
    appendix_letter = [*('A'..'Z')][page.count_in(:book) - 1]
    BakeAppendix.v1(page: page, number: appendix_letter)
    page.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(
        table: table,
        number: "#{appendix_letter}#{table.count_in(:page)}"
      )
    end
  end

  book.composite_pages.search('div[data-type="equation"]').each do |eq|
    eq.add_class('unnumbered')
  end
  BakeEquations.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeLinks.v1(book: book)
end
