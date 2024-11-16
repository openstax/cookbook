# frozen_string_literal: true

PL_NURSING_RECIPE = Kitchen::BookRecipe.new(book_short_name: :plnursing) do |doc, _resources|
  include Kitchen::Directions

  doc.selectors.override(
    reference: 'section.references'
  )
  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  BakeListsWithPara.v1(book: book)
  BakeUnnumberedFigure.v1(book: book)
  BakePreface.v1(book: book, cases: true)

  BakeChapterIntroductions.v2(
    book: book, options: {
      strategy: :add_objectives, bake_chapter_outline: true, introduction_order: :v3, cases: true
    }
  )
  BakeChapterTitle.v1(book: book, cases: true)

  answer_key = BookAnswerKeyContainer.v1(book: book)

  book.chapters.each do |chapter|
    BakeNonIntroductionPages.v1(chapter: chapter, options: { cases: true })
    BakeLearningObjectives.v2(chapter: chapter, add_title: false)

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}",
                    cases: true)
    end

    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}",
                           cases: true)
    end

    # EOC
    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      container_key: 'chapter-summary',
      uuid_key: '.chapter-summary',
      section_selector: 'section.chapter-summary'
    ) do |section|
      RemoveSectionTitle.v1(section: section)
    end

    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata, has_para: true)

    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      container_key: 'review-questions',
      uuid_key: '.review-questions',
      section_selector: 'section.review-questions'
    ) do |section|
      RemoveSectionTitle.v1(section: section)
    end

    BakeAllNumberedExerciseTypes.v1(
      within: chapter.search('section.review-questions'),
      exercise_options: { cases: true }
    )

    BakeAllNumberedExerciseTypes.v1(
      within: chapter.pages.notes('$.unfolding-casestudy'),
      exercise_options: { cases: true }
    )

    BakeSortableSection.v1(
      chapter: chapter,
      metadata_source: metadata,
      klass: 'suggested-reading'
    )

    answer_key_inner_container = AnswerKeyInnerContainer.v1(
      chapter: chapter, metadata_source: metadata, append_to: answer_key, options: { cases: true }
    )

    Kitchen::Directions::MoveSolutionsFromNumberedNote.v1(
      chapter: chapter, append_to: answer_key_inner_container, note_class: 'unfolding-casestudy'
    )

    Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
      within: chapter, append_to: answer_key_inner_container, section_class: 'review-questions'
    )

    chapter.exercises.each do |exercise|
      BakeFirstElements.v1(within: exercise)
    end
  end

  note_classes = %w[special-considerations clinical-tip safety-alert
                    unfolding-casestudy trending-today]

  BakeAutotitledNotes.v1(book: book, classes: note_classes, options: { cases: true })
  BakeCustomTitledNotes.v1(book: book, classes: %w[media-feature])
  BakeUnclassifiedNotes.v1(book: book)
  BakeUnnumberedTables.v1(book: book)
  BakeTableColumns.v1(book: book)
  BakeIframes.v1(book: book)
  BakeUnitTitle.v1(book: book)
  BakeReferences.v4(book: book, metadata_source: metadata, cases: true)
  BakeIndex.v1(book: book, types: %w[name term foreign], uuid_prefix: '.')
  BakeCompositePages.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeToc.v1(book: book, options: { cases: true })
  BakeFolio.v1(book: book)
  BakeRexWrappers.v1(book: book)
  BakeLinks.v1(book: book)
  BakeLinkPlaceholders.v1(book: book, cases: true)
end
