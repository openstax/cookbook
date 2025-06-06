# frozen_string_literal: true

NURSING_EXTERNAL_RECIPE = Kitchen::BookRecipe.new(book_short_name: :nursing_external) \
do |doc, _resources|
  include Kitchen::Directions

  doc.selectors.override(
    reference: 'section.references'
  )
  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  # Your recipe code goes here
  BakeUnnumberedFigure.v1(book: book)
  BakePreface.v1(book: book)
  AddInjectedExerciseId.v1(book: book)
  book.injected_exercises.each do |exercise|
    BakeInjectedExercise.v1(
      exercise: exercise
    )
  end

  answer_key = BookAnswerKeyContainer.v1(book: book)

  book.chapters.each do |chapter|
    BakeLearningObjectives.v2(chapter: chapter, add_title: false)
    BakeNonIntroductionPages.v1(chapter: chapter)

    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      container_key: 'chapter-summary',
      uuid_key: '.chapter-summary',
      section_selector: 'section.chapter-summary'
    )
    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      container_key: 'section-summary',
      uuid_key: '.section-summary',
      section_selector: 'section.section-summary'
    ) do |section|
      RemoveSectionTitle.v1(section: section)
      title = EocSectionTitleLinkSnippet.v1(page: section.ancestor(:page))
      section.prepend(child: title)
    end

    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata)

    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      container_key: 'review-questions',
      uuid_key: '.review-questions',
      section_selector: 'section.review-questions'
    ) do |section|
      RemoveSectionTitle.v1(section: section)
    end

    BakeSortableSection.v1(
      chapter: chapter,
      metadata_source: metadata,
      klass: 'suggested-reading'
    )

    chapter.search('section.review-questions').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(
        question: question,
        number: question.count_in(:chapter),
        options: { add_dot: true }
      )
      BakeFirstElements.v1(within: question)
    end

    chapter.pages.notes('$.unfolding-casestudy').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(
        question: question,
        number: question.count_in(:chapter),
        options: { only_number_solution: false, add_dot: true }
      )
    end

    chapter.pages.notes('$.single-casestudy').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(
        question: question,
        number: question.count_in(:chapter),
        options: { only_number_solution: false, add_dot: true }
      )
    end

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}")
    end

    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}")
    end

    answer_key_inner_container = AnswerKeyInnerContainer.v1(
      chapter: chapter, metadata_source: metadata, append_to: answer_key
    )
    # Solutions from note
    Kitchen::Directions::MoveSolutionsFromNumberedNote.v1(
      chapter: chapter, append_to: answer_key_inner_container, note_class: 'unfolding-casestudy'
    )
    Kitchen::Directions::MoveSolutionsFromNumberedNote.v1(
      chapter: chapter, append_to: answer_key_inner_container, note_class: 'single-casestudy'
    )
    # Solutions from other exercise sections
    Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
      within: chapter, append_to: answer_key_inner_container, section_class: 'review-questions'
    )
  end

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

  BakeUnnumberedTables.v1(book: book)
  BakeTableColumns.v1(book: book)
  BakeChapterIntroductions.v1(book: book)
  BakeChapterTitle.v1(book: book)
  BakeReferences.v4(book: book, metadata_source: metadata)
  BakeIframes.v1(book: book)
  BakeIndex.v1(book: book)
  BakeFolio.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeLinkPlaceholders.v1(book: book, replace_section_link_text: true)
  BakeUnitTitle.v1(book: book)
  BakeToc.v1(book: book)

  note_classes = %w[link-to-learning safety-alert clinical-tip health-alert healthy-people
                    trending-today culture-conversations theory-action special-considerations
                    black-box client-teaching practice-problems unfolding-casestudy
                    single-casestudy case-reflection]
  BakeAutotitledNotes.v1(book: book, classes: note_classes)
  BakeCustomTitledNotes.v1(book: book, classes: %w[media-feature boxed-feature])
  # BakeCustomTitledNotes.v1(book: book, classes: %w[media-feature])
  BakeUnclassifiedNotes.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeRexWrappers.v1(book: book)
  BakeLinks.v1(book: book)
end
