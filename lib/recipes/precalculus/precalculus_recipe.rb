# frozen_string_literal: true

require_relative '../recipes_helper'
require_relative 'strategy'

# Used in precalculus (bakes precalculus, trigonometry, and college-algebra)
# and precalculus-coreq (bakes college-algebra-coreq)
PRECALCULUS_RECIPE = Kitchen::BookRecipe.new(book_short_name: :precalculus) do |doc, _resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  # BakeImages.v1(book: book, resources: resources)

  book.search('section.coreq-skills').each do |coreq_section|
    coreq_section.tables.each { |table| table.add_class('os-coreq-element') }
    coreq_section.figures.each { |table| table.add_class('os-coreq-element') }
    coreq_section.examples.each { |table| table.add_class('os-coreq-element') }
  end

  BakePreface.v1(book: book)
  BakeChapterIntroductions.v1(book: book)
  BakeChapterTitle.v1(book: book)
  book.chapters.each do |chapter|
    BakeLearningObjectives.v1(chapter: chapter)
    BakeNonIntroductionPages.v1(chapter: chapter)
  end

  BakeAutotitledNotes.v1(book: book, classes: %w[how-to-notitle qa media-notitle])
  BakeUnclassifiedNotes.v1(book: book)
  BakeNumberedNotes.v2(book: book, classes: %w[try])

  # Bake EOC sections
  book.chapters.each do |chapter|
    eoc_wrapper = ChapterReviewContainer.v1(chapter: chapter, metadata_source: metadata)

    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata, append_to: eoc_wrapper)
    BakeChapterKeyEquations.v1(chapter: chapter, metadata_source: metadata, append_to: eoc_wrapper)
    BakeChapterKeyConcepts.v1(chapter: chapter, metadata_source: metadata, append_to: eoc_wrapper)
    # EoC sections with exercises
    eoc_exercises_wrapper = ChapterReviewContainer.v1(chapter: chapter, metadata_source: metadata,
                                                      klass: 'exercises')
    %w[review-exercises practice-test].each do |klass|
      Kitchen::Directions::MoveCustomSectionToEocContainer.v1(
        chapter: chapter,
        metadata_source: metadata,
        container_key: klass,
        uuid_key: ".#{klass}",
        section_selector: "section.#{klass}",
        append_to: eoc_exercises_wrapper
      ) do |exercise_section|
        Kitchen::Directions::RemoveSectionTitle.v1(section: exercise_section)
        exercise_section.search('section').each do |section|
          section.first('h4')&.name = 'h5'
        end
      end
    end
    BakeChapterSectionExercises.v1(chapter: chapter, options: { trash_title: true })
    # In-place bake exercises & solutions
    chapter.search('section.review-exercises').exercises.each do |exercise|
      BakeNumberedExercise.v1(exercise: exercise, number: exercise.count_in(:chapter))
    end
    chapter.search('section.practice-test').exercises.each do |exercise|
      BakeNumberedExercise.v1(exercise: exercise, number: exercise.count_in(:chapter))
    end
    chapter.pages.search('section.section-exercises').exercises.each do |exercise|
      BakeNumberedExercise.v1(exercise: exercise, number: exercise.count_in(:page))
    end
  end

  book.search('div.try, section.section-exercises, section.review-exercises')\
      .search('div[data-type="solution"]').tables.each do |table|
    table.add_class('unnumbered')
  end

  # Tables and figures must be baked after EOC sections are created to preserve number ordering
  book.pages('$:not(.appendix)').each do |page|
    page.tables('$:not(.unnumbered):not(.os-coreq-element)').each do |table|
      BakeNumberedTable.v2(table: table, number: table.count_in(:page))
    end
    page.figures('$:not(.os-coreq-element)', only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure, number: figure.count_in(:page))
    end
    page.examples('$:not(.os-coreq-element)').each do |example|
      BakeExample.v1(example: example, number: example.count_in(:page), title_tag: 'h3')
    end
  end

  BakeUnnumberedFigure.v1(book: book)

  book.composite_pages.each do |page|
    page.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v2(table: table, number: table.count_in(:composite_page))
    end
    page.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure, number: figure.count_in(:composite_page))
    end
  end

  book.pages('$.appendix').each do |page|
    appendix_letter = [*('A'..'Z')][page.count_in(:book) - 1]
    BakeAppendix.v1(page: page, number: appendix_letter)

    page.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v2(table: table, number: "#{appendix_letter}#{table.count_in(:page)}")
    end
    page.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure, number: "#{appendix_letter}#{figure.count_in(:page)}")
    end
  end

  BakeUnnumberedTables.v1(book: book)

  solutions_container = BookAnswerKeyContainer.v1(book: book, solutions_plural: false)
  book.chapters.each do |chapter|
    # BakeFirstElements is most efficiently called before solutions are separated from exercises
    # BakeFirstElements must also be called after tables are baked.
    chapter.search('section.review-exercises, section.practice-test, section.section-exercises,' \
      ' div[data-type="note"].try').exercises.each do |exercise|
      # Classes added: has-first-element; has-first-inline-list-element
      BakeFirstElements.v1(within: exercise, first_inline_list: true)
    end

    answer_key_inner_container = AnswerKeyInnerContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      append_to: solutions_container,
      options: { solutions_plural: false }
    )

    Strategy.new.bake(
      chapter: chapter,
      append_to: answer_key_inner_container
    )
  end

  BakeScreenreaderSpans.v1(book: book)
  BakeInlineLists.v1(book: book)
  BakeEquations.v1(book: book)
  BakeMathInParagraph.v1(book: book)
  BakeIndex.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeStepwise.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeLinks.v1(book: book)
end
