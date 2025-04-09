# frozen_string_literal: true

ALGEBRA_1_RECIPE = Kitchen::BookRecipe.new(book_short_name: :raise) do |doc, _resources|
  include Kitchen::Directions
  
  book = doc.book
  book_metadata = book.metadata
  
  book.units.each_with_index do |unit, idx|
    unit[:'data-numbered-unit'] = "true" if idx > 1
  end
  # Some stuff just goes away
  book.search('cnx-pi').trash

  BakeUnnumberedFigure.v1(book: book)
  # BakePreface.v1(book: book)
  book.pages('$.preface').each(&:trash)
  BakeUnclassifiedNotes.v1(book: book)
  BakeIframes.v1(book: book)

  # book.notes('$.theorem').each { |theorem| theorem['use-subtitle'] = true }

  # BakeAutotitledNotes.v1(book: book, classes: %w[media-2 problem-solving project])
  # BakeNumberedNotes.v1(book: book, classes: %w[theorem checkpoint])

  # book.chapters.each do |chapter|
    # chapter_review = ChapterReviewContainer.v1(
    #   chapter: chapter,
    #   metadata_source: book_metadata
    # )

    # BakeChapterGlossary.v1(
    #   chapter: chapter, metadata_source: book_metadata, append_to: chapter_review
    # )
    # BakeChapterKeyEquations.v1(
    #   chapter: chapter, metadata_source: book_metadata, append_to: chapter_review
    # )
    # BakeChapterKeyConcepts.v1(
    #   chapter: chapter, metadata_source: book_metadata, append_to: chapter_review
    # )
    # MoveExercisesToEOC.v1(
    #   chapter: chapter, metadata_source: book_metadata,
    #   append_to: chapter_review, klass: 'review-exercises'
    # )
    # BakeChapterSectionExercises.v1(chapter: chapter)

    # Just above we moved the review exercises to the end of the chapter. Now that all of the
    # non-checkpoint exercises are in the right order, we bake them (the "in place" modifications)
    # and number them.
    # chapter.search('section.section-exercises, section.review-exercises').exercises.each \
    # do |exercise|
    #   BakeNumberedExercise.v1(exercise: exercise, number: exercise.count_in(:chapter))
    # end
  # end

  # BakeChapterIntroductions.v2(book: book,
  #                           chapters: book.units.chapters,
  #                           options: { numbering_options: { mode: :unit_chapter_page } })
  BakeChapterTitle.v2(chapters: book.units.chapters, numbering_options: { mode: :unit_chapter_page })

  book.units('$[data-numbered-unit="true"]').chapters.each do |chapter|
    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                          number: table.os_number({ mode: :unit_chapter_page }))
    end

    chapter.examples.each do |example|
      BakeExample.v1(example: example,
                    number: example.os_number({ mode: :unit_chapter_page }),
                    title_tag: 'h3')
    end

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: figure.os_number({ mode: :unit_chapter_page }))
    end
    BakeNonIntroductionPages.v1(chapter: chapter, options: { numbering_options: { mode: :unit_chapter_page } })
  end

  book.pages('$.appendix').each do |page|
    appendix_letter = [*('A'..'Z')][page.count_in(:book) - 1]

    page.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure, number: "#{appendix_letter}#{figure.count_in(:page)}")
    end

    page.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table, number: "#{appendix_letter}#{table.count_in(:page)}")
    end

    page.examples.each do |example|
      BakeExample.v1(example: example,
                     number: "#{appendix_letter}#{example.count_in(:page)}",
                     title_tag: 'div')
    end

    BakeAppendix.v1(page: page, number: appendix_letter)
  end

  # Here we move the solutions to the end of the book. Calculus has an "Answer Key" composite
  # chapter after the appendices. So we make the answer key, then iterate over the chapters, making
  # an answer key composite page for each chapter that we append to the answer key composite chapter
  # book_answer_key = BookAnswerKeyContainer.v1(book: book)

  # book.units.chapters.each do |chapter|
  #   answer_key_inner_container = AnswerKeyInnerContainer.v1(
  #     chapter: chapter, metadata_source: book_metadata, append_to: book_answer_key
  #   )
  #   # Bake solutions
  #   MoveSolutionsFromAutotitledNote.v1(
  #     page: chapter, append_to: answer_key_inner_container, note_class: 'checkpoint',
  #     title: I18n.t(:'notes.checkpoint')
  #   )
  #   chapter.sections('$.section-exercises').each do |section|
  #     number = "#{chapter.count_in(:book)}.#{section.count_in(:chapter)}"
  #     MoveSolutionsFromExerciseSection.v1(
  #       within: section, append_to: answer_key_inner_container, section_class: 'section-exercises',
  #       title_number: number
  #     )
  #   end
  #   MoveSolutionsFromExerciseSection.v1(
  #     within: chapter, append_to: answer_key_inner_container, section_class: 'review-exercises'
  #   )
  # end

  BakeStepwise.v1(book: book)
  BakeUnnumberedTables.v1(book: book)

  book.search('section.section-exercises', 'div.os-eob.os-solutions-container').each do |within|
    BakeFirstElements.v1(within: within)
  end

  # BakeMathInParagraph.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeUnitTitle.v1(book: book)
  BakeUnitPageTitle.v1(book: book)
  BakeToc.v1(book: book, options: { numbering_options: { mode: :unit_chapter_page } })
  BakeEquations.v1(book: book, number_decorator: :parentheses)
  BakeFolio.v1(book: book, chapters: book.units.chapters, options: { numbering_options: { mode: :unit_chapter_page } } )

  book.chapters.each do |chapter|
    BakeLearningObjectives.v2(chapter: chapter)
  end

  BakeRexWrappers.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeLinks.v1(book: book)

end
