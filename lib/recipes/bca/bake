#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../recipes_helper'

recipe = Kitchen::BookRecipe.new(book_short_name: :bca) do |doc, resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  # Some stuff just goes away
  book.search('cnx-pi').trash

  BakeImages.v1(book: book, resources: resources)
  BakePreface.v1(book: book)
  BakeUnnumberedFigure.v1(book: book)

  BakeChapterTitle.v1(book: book)
  BakeChapterIntroductions.v2(
    book: book, options: {
      strategy: :add_objectives, bake_chapter_outline: true
    }
  )

  AddInjectedExerciseId.v1(book: book)
  book.injected_exercises.each do |exercise|
    BakeInjectedExercise.v1(exercise: exercise)
  end

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

    # EOC sections
    eoc_wrapper = ChapterReviewContainer.v1(chapter: chapter, metadata_source: metadata)

    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata, append_to: eoc_wrapper)

    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      container_key: 'section-summary',
      uuid_key: '.section-summary',
      section_selector: 'section.section-summary',
      append_to: eoc_wrapper,
      wrap_section: true,
      wrap_content: true
    ) do |section|
      RemoveSectionTitle.v1(section: section)
      title = EocSectionTitleLinkSnippet.v1(page: section.ancestor(:page), title_tag: 'h4')
      section.prepend(child: title)
    end

    eoc_sections = %w[review-questions conceptual-questions you-try practice-exercises
                      written-questions case-exercises extension-exercises]

    eoc_sections.each do |klass|
      Kitchen::Directions::MoveCustomSectionToEocContainer.v1(
        chapter: chapter,
        metadata_source: metadata,
        container_key: klass,
        uuid_key: ".#{klass}",
        section_selector: "section.#{klass}",
        append_to: eoc_wrapper
      ) do |exercise_section|
        Kitchen::Directions::RemoveSectionTitle.v1(section: exercise_section)
        exercise_section.search('section').each do |section|
          section.first('h4').name = 'h5'
        end
      end
    end

    selectors = 'section.review-questions, section.conceptual-questions,
                 section.you-try, section.practice-exercises,
                 section.written-questions, section.case-exercises,
                 section.extension-exercises'

    chapter.composite_pages.search(selectors).injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(question: question, number: question.count_in(:chapter))
    end
  end

  notes = %w[real-application spotlight-ethics link-to-learning]
  BakeAutotitledNotes.v1(book: book, classes: notes)

  BakeAutotitledNotes.v1(
    book: book,
    classes: %w[mac-tip],
    options: { bake_exercises: true }
  )

  book.pages('$.appendix').each do |page|
    appendix_letter = [*('A'..'Z')][page.count_in(:book) - 1]
    BakeAppendix.v1(page: page, number: appendix_letter)

    page.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table, number: "#{appendix_letter}#{table.count_in(:page)}")
    end
    page.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure, number: "#{appendix_letter}#{figure.count_in(:page)}")
    end
  end

  BakeIframes.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeToc.v1(book: book)
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
