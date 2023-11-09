# frozen_string_literal: true

PYTHON_RECIPE = Kitchen::BookRecipe.new(book_short_name: :python) do |doc, _resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  BakePreface.v1(book: book)
  BakeUnnumberedFigure.v1(book: book)
  BakeUnclassifiedNotes.v1(book: book)
  BakeIframes.v1(book: book)
  BakeUnnumberedTables.v1(book: book)

  AddInjectedExerciseId.v1(book: book)
  book.injected_exercises.each do |exercise|
    BakeInjectedExercise.v1(exercise: exercise)
  end

  BakeHighlightedCode.v1(book: book, languages: ['python'])

  notes = %w[guided-slides learning-questions practice-program]
  BakeAutotitledNotes.v1(book: book, classes: notes, options: { bake_exercises: false })

  answer_key = BookAnswerKeyContainer.v1(book: book)

  book.pages('$.preface').each do |page|
    page.notes('$.learning-questions').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(
        question: question,
        number: question.count_in(:page),
        options: { only_number_solution: false }
      )
    end

    answer_key_preface_inner_container = AnswerKeyInnerContainer.v1(
      chapter: page, metadata_source: metadata, append_to: answer_key,
      options: { solutions_plural: false, in_preface: true }
    )
    Kitchen::Directions::MoveSolutionsFromAutotitledNote.v1(
      page: page, append_to: answer_key_preface_inner_container,
      note_class: 'learning-questions', title: nil
    )
  end

  BakeChapterTitle.v1(book: book)

  BakeChapterIntroductions.v2(
    book: book, options: {
      strategy: :add_objectives, bake_chapter_outline: true
    }
  )

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

    chapter.examples.each do |example|
      BakeExample.v1(example: example,
                     number: "#{chapter.count_in(:book)}.#{example.count_in(:chapter)}",
                     title_tag: 'h3')
    end

    chapter.pages.notes('$.learning-questions').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(
        question: question,
        number: question.count_in(:page),
        options: { only_number_solution: false, add_dot: true }
      )
    end

    answer_key_inner_container = AnswerKeyInnerContainer.v1(
      chapter: chapter, metadata_source: metadata, append_to: answer_key
    )
    chapter.non_introduction_pages.each do |page|
      title = page.title.children
      Kitchen::Directions::MoveSolutionsFromAutotitledNote.v1(
        page: page, append_to: answer_key_inner_container, note_class: 'learning-questions',
        title: title
      )
    end
  end

  BakeFootnotes.v1(book: book, number_format: :roman) # check if exists
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeLinks.v1(book: book)
end
