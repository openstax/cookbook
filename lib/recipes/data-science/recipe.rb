# frozen_string_literal: true

DATA_SCIENCE_RECIPE = Kitchen::BookRecipe.new(book_short_name: :data_science) \
do |doc, _resources|
  include Kitchen::Directions

  doc.selectors.override(
    reference: 'section.references'
  )

  book = doc.book

  book.search('cnx-pi').trash
  metadata = book.metadata

  BakePreface.v1(book: book)
  BakeUnnumberedFigure.v1(book: book)
  BakeUnnumberedTables.v1(book: book)

  AddInjectedExerciseId.v1(book: book)
  book.injected_exercises.each do |exercise|
    BakeInjectedExercise.v1(
      exercise: exercise,
      options: {
        alphabetical_multiparts: true,
        list_type: 'lower-alpha',
        suppress_summary: true
      }
    )
  end

  BakeChapterTitle.v1(book: book)
  BakeChapterIntroductions.v1(book: book)

  answer_key = BookAnswerKeyContainer.v1(book: book)

  book.chapters.each do |chapter|
    BakeNonIntroductionPages.v1(chapter: chapter)
    BakeLearningObjectives.v2(chapter: chapter, add_title: false)

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}")
    end

    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v2(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}")
    end

    chapter.examples.each do |example|
      BakeExample.v1(example: example,
                     number: "#{chapter.count_in(:book)}.#{example.count_in(:chapter)}",
                     title_tag: 'h3')
    end

    # EOC
    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata)

    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      container_key: 'group-project',
      uuid_key: '.group-project',
      section_selector: 'section.group-project'
    )

    eoc_sections = %w[chapter-review critical-thinking quantitative-problems]

    eoc_sections.each do |section_key|
      MoveCustomSectionToEocContainer.v1(
        chapter: chapter,
        metadata_source: metadata,
        container_key: section_key,
        uuid_key: ".#{section_key}",
        section_selector: "section.#{section_key}"
      ) do |section|
        RemoveSectionTitle.v1(section: section)
      end
    end

    chapter.search('section.chapter-review').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(question: question, number: question.count_in(:chapter))
      BakeFirstElements.v1(within: question)
    end

    chapter.search('section.critical-thinking').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(question: question, number: question.count_in(:chapter))
      BakeFirstElements.v1(within: question)
    end

    chapter.search('section.quantitative-problems').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(
        question: question,
        number: question.count_in(:chapter),
        options: { suppress_summary: true }
      )
      BakeFirstElements.v1(within: question)
    end

    BakeChapterReferences.v3(chapter: chapter, metadata_source: metadata)

    # Answer Key
    answer_key_inner_container = AnswerKeyInnerContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      append_to: answer_key
    )

    eoc_sections.each do |klass|
      Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
        within: chapter, append_to: answer_key_inner_container, section_class: klass
      )
    end
  end

  book.search('div[data-type="question-solution"]').each do |solution|
    BakeFirstElements.v1(within: solution)
  end

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

  BakeTableColumns.v1(book: book)
  BakeEquations.v1(book: book)
  BakeIndex.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeRexWrappers.v1(book: book)
  BakeLinks.v1(book: book)

  note_classes = %w[exploring-further python-feature]
  BakeAutotitledNotes.v1(book: book, classes: note_classes)

  BakeCustomTitledNotes.v1(book: book, classes: %w[boxed-feature download-file])
end
