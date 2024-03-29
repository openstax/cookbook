# frozen_string_literal: true

U_PHYSICS_RECIPE = Kitchen::BookRecipe.new(book_short_name: :uphysics) do |doc, _resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  BakeUnnumberedFigure.v1(book: book)
  BakePreface.v1(book: book)
  BakeChapterIntroductions.v1(book: book)
  BakeChapterTitle.v1(book: book)
  book.chapters.each do |chapter|
    BakeLearningObjectives.v1(chapter: chapter)
    BakeNonIntroductionPages.v1(chapter: chapter)
  end

  # Bake the notes
  BakeAutotitledNotes.v1(book: book, classes: %w[media-2 problem-solving])
  BakeUnclassifiedNotes.v1(book: book)
  BakeNumberedNotes.v1(book: book, classes: %w[check-understanding])

  # Bake EOC sections
  solutions_container = BookAnswerKeyContainer.v1(book: book)
  book.chapters.each do |chapter|
    eoc_wrapper = ChapterReviewContainer.v1(chapter: chapter, metadata_source: metadata)

    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata, append_to: eoc_wrapper)
    BakeChapterKeyEquations.v1(chapter: chapter, metadata_source: metadata, append_to: eoc_wrapper)
    BakeChapterKeyConcepts.v1(chapter: chapter, metadata_source: metadata, append_to: eoc_wrapper)
    # EoC sections with exercises
    MoveExercisesToEOC.v2(chapter: chapter, metadata_source: metadata, append_to: eoc_wrapper,
                          klass: 'review-conceptual-questions')
    MoveExercisesToEOC.v2(chapter: chapter, metadata_source: metadata, append_to: eoc_wrapper,
                          klass: 'review-problems')
    MoveExercisesToEOC.v1(chapter: chapter, metadata_source: metadata, append_to: eoc_wrapper,
                          klass: 'review-additional-problems')
    MoveExercisesToEOC.v1(chapter: chapter, metadata_source: metadata, append_to: eoc_wrapper,
                          klass: 'review-challenge')
    # In-place bake exercises & solutions
    exercise_selectors = 'section.review-conceptual-questions, section.review-problems, ' \
                         'section.review-additional-problems, section.review-challenge'
    chapter.search(exercise_selectors).exercises.each do |exercise|
      BakeNumberedExercise.v1(exercise: exercise, number: exercise.count_in(:chapter))
    end

    # Bake answer key from chapter/ move solutions from eoc into answer key
    answer_key_inner_container = AnswerKeyInnerContainer.v1(
      chapter: chapter, metadata_source: metadata, append_to: solutions_container
    )
    Kitchen::Directions::MoveSolutionsFromNumberedNote.v1(
      chapter: chapter, append_to: answer_key_inner_container, note_class: 'check-understanding'
    )
    exercise_section_classes = %w[review-conceptual-questions review-problems
                                  review-additional-problems review-challenge]
    exercise_section_classes.each do |klass|
      Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
        within: chapter, append_to: answer_key_inner_container, section_class: klass
      )
    end
  end

  book.search('div[data-type="solution"]').each do |solution|
    # Add the 'has-first-element' class to elements that need it
    BakeFirstElements.v1(within: solution)
  end

  book.chapters.each do |chapter|
    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}")
    end

    chapter.examples.each do |example|
      BakeExample.v1(example: example,
                     number: "#{chapter.count_in(:book)}.#{example.count_in(:chapter)}",
                     title_tag: 'h3')
    end

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}")
    end
  end

  book.pages('$.appendix').each do |page|
    appendix_letter = [*('A'..'Z')][page.count_in(:book) - 1]
    BakeAppendix.v1(page: page, number: appendix_letter)

    page.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table, number: "#{appendix_letter}#{table.count_in(:page)}")
    end
  end

  BakeIframes.v1(book: book)
  BakeUnnumberedTables.v1(book: book)
  BakeEquations.v1(book: book)
  BakeMathInParagraph.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeUnitTitle.v1(book: book)
  BakeFolio.v1(book: book)
  BakeRexWrappers.v1(book: book)
  BakeLinks.v1(book: book)
end
