# frozen_string_literal: true

SUPER_RECIPE = Kitchen::BookRecipe.new(book_short_name: :super) do |doc, _resources|
  include Kitchen::Directions

  # Setup
  book = doc.book
  book_metadata = book.metadata
  autotitled_notes = %w[]
  numbered_notes = %w[]
  custom_titled_notes = %w[]
  numbered_exercise_sections = 'section.section-exercises, section.review-exercises'
  book.search('cnx-pi').trash

  BakeUnnumberedFigure.v1(book: book)
  BakePreface.v1(book: book)
  BakeUnclassifiedNotes.v1(book: book)
  BakeCustomTitledNotes.v1(book: book, classes: custom_titled_notes)

  BakeAutotitledNotes.v1(book: book, classes: autotitled_notes)
  BakeNumberedNotes.v1(book: book, classes: numbered_notes)

  AddInjectedExerciseId.v1(book: book)
  book.injected_exercises.each do |exercise|
    BakeInjectedExercise.v1(exercise: exercise)
  end

  book.chapters.each do |chapter|
    chapter_review = ChapterReviewContainer.v1(
      chapter: chapter,
      metadata_source: book_metadata
    )

    BakeChapterGlossary.v1(
      chapter: chapter, metadata_source: book_metadata, append_to: chapter_review
    )
    BakeChapterKeyEquations.v1(
      chapter: chapter, metadata_source: book_metadata, append_to: chapter_review
    )
    BakeChapterKeyConcepts.v1(
      chapter: chapter, metadata_source: book_metadata, append_to: chapter_review
    )
    MoveExercisesToEOC.v1(
      chapter: chapter, metadata_source: book_metadata,
      append_to: chapter_review, klass: 'review-exercises'
    )
    BakeChapterSectionExercises.v1(chapter: chapter)

    chapter.search(numbered_exercise_sections).exercises.each do |exercise|
      BakeNumberedExercise.v1(exercise: exercise, number: exercise.count_in(:chapter))
    end
  end

  # BakeChapterIntroductions.v1(book: book)
  BakeChapterTitle.v1(book: book)

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

    BakeNonIntroductionPages.v1(chapter: chapter)
  end

  book_answer_key = BookAnswerKeyContainer.v1(book: book)

  book.chapters.each do |chapter|
    answer_key_inner_container = AnswerKeyInnerContainer.v1(
      chapter: chapter, metadata_source: book_metadata, append_to: book_answer_key
    )
    # Bake solutions
    MoveSolutionsFromAutotitledNote.v1(
      page: chapter, append_to: answer_key_inner_container, note_class: 'checkpoint',
      title: I18n.t(:'notes.checkpoint')
    )
    chapter.sections('$.section-exercises').each do |section|
      number = "#{chapter.count_in(:book)}.#{section.count_in(:chapter)}"
      MoveSolutionsFromExerciseSection.v1(
        within: section, append_to: answer_key_inner_container, section_class: 'section-exercises',
        title_number: number
      )
    end
    MoveSolutionsFromExerciseSection.v1(
      within: chapter, append_to: answer_key_inner_container, section_class: 'review-exercises'
    )
  end

  BakeStepwise.v1(book: book)
  BakeUnnumberedTables.v1(book: book)

  book.search('section.section-exercises', 'div.os-eob.os-solutions-container').each do |within|
    BakeFirstElements.v1(within: within)
  end

  begin
    BakeMathInParagraph.v1(book: book)
  rescue StandardError
    puts 'No math in collection'
  end
  AnswerKeyCleaner.v1(book: book, options: { remove_empty_container: true })
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeToc.v1(book: book)
  BakeEquations.v1(book: book, number_decorator: :parentheses)

  book.chapters.each do |chapter|
    BakeLearningObjectives.v2(chapter: chapter, skip_title_if_exists: true)
  end

  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeRexWrappers.v1(book: book)
  BakeLinks.v1(book: book)
end
