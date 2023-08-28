#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'strategy'
require_relative '../recipes_helper'

recipe = Kitchen::BookRecipe.new(book_short_name: :contemporary_math) do |doc, resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  BakeImages.v1(book: book, resources: resources)
  BakePreface.v1(book: book)

  BakeChapterIntroductions.v1(book: book)
  BakeChapterTitle.v1(book: book)
  AddInjectedExerciseId.v1(book: book)
  BakeUnclassifiedNotes.v1(book: book)
  note_classes =
    %w[people-mathematics who-knew tech-check check-point video work-out definition formula]
  BakeAutotitledNotes.v1(book: book, classes: note_classes)
  BakeNumberedNotes.v1(book: book, classes: %w[your-turn], options: { bake_exercises: false })
  sections_with_unnumbered_tables_in_solutions = \
    'div.your-turn, section.section-exercises, section.chapter-review, section.chapter-test'
  book.search(sections_with_unnumbered_tables_in_solutions).solutions.each do |solution|
    solution.tables.each do |table|
      table.add_class('unnumbered')
    end
    solution.figures.each do |figure|
      figure.add_class('unnumbered')
    end
  end
  BakeUnnumberedFigure.v1(book: book)
  BakeUnnumberedTables.v1(book: book)

  book.injected_exercises.each do |exercise|
    BakeInjectedExercise.v1(exercise: exercise)
  end
  answer_key = BookAnswerKeyContainer.v1(book: book)
  book.chapters.each do |chapter|
    BakeLearningObjectives.v1(chapter: chapter)
    BakeNonIntroductionPages.v1(chapter: chapter)

    BakeChapterSectionExercises.v1(chapter: chapter, options: { trash_title: true })

    chapter.pages.sections('$.check-understanding').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(question: question, number: question.count_in(:chapter))
      BakeFirstElements.v1(within: question)
    end
    chapter.pages.search('section.section-exercises').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(question: question, number: question.count_in(:page))
      BakeFirstElements.v1(within: question)
    end
    chapter.pages.search('section.chapter-review').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(question: question, number: question.count_in(:chapter))
      BakeFirstElements.v1(within: question)
    end
    chapter.pages.search('section.chapter-test').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(question: question, number: question.count_in(:chapter))
      BakeFirstElements.v1(within: question)
    end
    chapter.pages.notes('$.your-turn').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(
        question: question,
        number: question.count_in(:note),
        options: { only_number_solution: false }
      )
      BakeFirstElements.v1(within: question)
    end

    chapter_summary = \
      ChapterReviewContainer.v1(chapter: chapter, metadata_source: metadata,
                                klass: 'chapter-summary')
    eoc_sections = %w[key-terms key-concepts eoc-videos formula-review]
    eoc_sections.each do |section_key|
      MoveCustomSectionToEocContainer.v1(
        chapter: chapter,
        metadata_source: metadata,
        container_key: section_key,
        uuid_key: ".#{section_key}",
        section_selector: "section.#{section_key}",
        append_to: chapter_summary,
        wrap_section: true, wrap_content: true
      ) do |section|
        RemoveSectionTitle.v1(section: section)
        title = EocSectionTitleLinkSnippet.v1(page: section.ancestor(:page))
        section.prepend(child: title)
      end
    end
    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      container_key: 'projects',
      uuid_key: '.projects',
      section_selector: 'section.projects',
      append_to: chapter_summary
    ) do |section|
      RemoveSectionTitle.v1(section: section)
    end
    eoc_with_exercise = %w[chapter-review chapter-test]
    eoc_with_exercise.each do |section_key|
      MoveCustomSectionToEocContainer.v1(
        chapter: chapter,
        metadata_source: metadata,
        container_key: section_key,
        uuid_key: ".#{section_key}",
        section_selector: "section.#{section_key}",
        append_to: chapter_summary
      ) do |section|
        ChangeSubsectionTitleTag.v1(section: section)
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
    chapter.examples.each do |example|
      BakeExample.v1(example: example,
                     number: "#{chapter.count_in(:book)}.#{example.count_in(:chapter)}",
                     title_tag: 'h3')
    end

    chapter.search('div[data-type="exercise"]').each do |exercise|
      # Classes added: has-first-element
      BakeFirstElements.v1(within: exercise)
    end

    answer_key_inner_container = AnswerKeyInnerContainer.v1(
      chapter: chapter, metadata_source: metadata, append_to: answer_key
    )

    Strategy.new.bake(
      chapter: chapter,
      append_to: answer_key_inner_container
    )
  end

  book.pages('$.appendix').each do |page|
    appendix_letter = [*('A'..'Z')][page.count_in(:book) - 1]

    page.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{appendix_letter}#{figure.count_in(:page)}",
                    label_class: 'figure-target-label')
    end

    page.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{appendix_letter}#{table.count_in(:page)}",
                           label_class: 'table-target-label')
    end

    page.examples.each do |example|
      BakeExample.v1(example: example,
                     number: "#{appendix_letter}#{example.count_in(:page)}",
                     title_tag: 'h3')
    end

    BakeAppendix.v1(page: page, number: appendix_letter)
  end

  BakeIframes.v1(book: book)
  BakeEquations.v1(book: book)
  BakeMathInParagraph.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeCompositeChapters.v1(book: book)
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
