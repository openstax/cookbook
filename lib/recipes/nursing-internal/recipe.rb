# frozen_string_literal: true

NURSING_INTERNAL_RECIPE = Kitchen::BookRecipe.new(book_short_name: :nursing_internal) \
do |doc, resources|
  include Kitchen::Directions

  doc.selectors.override(
    reference: 'section.references'
  )
  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  # Your recipe code goes here
  BakeImages.v1(book: book, resources: resources)
  BakePreface.v1(book: book)

  BakeUnnumberedFigure.v1(book: book)
  BakeUnnumberedTables.v1(book: book)

  AddInjectedExerciseId.v1(book: book)
  book.injected_exercises.each do |exercise|
    BakeInjectedExercise.v1(
      exercise: exercise
    )
  end

  answer_key = BookAnswerKeyContainer.v1(book: book)

  BakeChapterIntroductions.v1(book: book)
  BakeChapterTitle.v1(book: book)

  book.chapters.each do |chapter|
    BakeLearningObjectives.v1(chapter: chapter)
    BakeNonIntroductionPages.v1(chapter: chapter)

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}"
                    )
    end

    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}")
    end

    # EOC
    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      container_key: 'summary',
      uuid_key: '.summary',
      section_selector: 'section.summary'
    ) do |section|
      RemoveSectionTitle.v1(section: section)
    end

    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata)

    eoc_wrapper = ChapterReviewContainer.v1(
      chapter: chapter,
      metadata_source: metadata
    )

    sections_with_module_links = %w[review-questions check-understanding reflection-questions
                                    critical-thinking what-nurses-do competency-based]

    sections_with_module_links.each do |eoc_section|
      MoveCustomSectionToEocContainer.v1(
        chapter: chapter,
        metadata_source: metadata,
        container_key: eoc_section,
        uuid_key: ".#{eoc_section}",
        section_selector: "section.#{eoc_section}",
        append_to: eoc_wrapper
      ) do |section|
        RemoveSectionTitle.v1(section: section)
      end
    end

    BakeChapterReferences.v3(chapter: chapter, metadata_source: metadata)

    # Exercises
    chapter.search('section.review-questions').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(question: question, number: question.count_in(:chapter))
      BakeFirstElements.v1(within: question)
    end

    chapter.search('section.check-understanding').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(question: question, number: question.count_in(:chapter))
      BakeFirstElements.v1(within: question)
    end

    chapter.search('section.critical-thinking').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(question: question, number: question.count_in(:chapter))
      BakeFirstElements.v1(within: question)
    end

    chapter.search('section.competency-based').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(question: question, number: question.count_in(:chapter))
      BakeFirstElements.v1(within: question)
    end

    chapter.search('section.reflection-questions').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(question: question, number: question.count_in(:chapter))
      BakeFirstElements.v1(within: question)
    end

    chapter.search('section.what-nurses-do').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(question: question, number: question.count_in(:chapter))
      BakeFirstElements.v1(within: question)
    end

    # Answer Key
    answer_key_inner_container = AnswerKeyInnerContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      append_to: answer_key
    )

    exercises = %w[review-questions check-understanding
                   critical-thinking competency-based
                   reflection-questions what-nurses-do]

    exercises.each do |klass|
      Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
        chapter: chapter, append_to: answer_key_inner_container, section_class: klass
      )
    end
  end

  book.search('div[data-type="question-solution"]').each do |solution|
    BakeFirstElements.v1(within: solution)
  end

  note_classes = %w[link-to-learning unfolding-casestudy rn-stories clinical-safety
                    cultural-context patient-conversations pharma-connections legal-ethical
                    multi-disciplinary clinical-judgment electronic-hr psychosocial-considerations]
  BakeAutotitledNotes.v1(book: book, classes: note_classes)

  # Appendix
  book.pages('$.appendix').each do |page|
    appendix_letter = [*('A'..'Z')][page.count_in(:book) - 1]

    page.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure, number: "#{appendix_letter}#{figure.count_in(:page)}")
    end

    page.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table, number: "#{appendix_letter}#{table.count_in(:page)}")
    end
    BakeAppendix.v1(page: page, number: appendix_letter)
  end

  BakeUnitTitle.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeLinks.v1(book: book)
end



