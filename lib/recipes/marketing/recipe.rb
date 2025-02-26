# frozen_string_literal: true

MARKETING_RECIPE = Kitchen::BookRecipe.new(book_short_name: :marketing) do |doc, _resources|
  include Kitchen::Directions

  # Set overrides
  doc.selectors.override(
    reference: 'section.references'
  )

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  BakePreface.v1(book: book)

  book.pages('$.preface').each do |page|
    page.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: table.count_in(:page).to_s)
    end
  end

  BakeChapterIntroductions.v2(
    book: book, options: {
      strategy: :add_objectives, bake_chapter_outline: true, introduction_order: :v3
    }
  )
  BakeChapterTitle.v1(book: book)

  BakeUnnumberedFigure.v1(book: book)
  BakeUnclassifiedNotes.v1(book: book)
  AddInjectedExerciseId.v1(book: book)

  answer_key = BookAnswerKeyContainer.v1(book: book, solutions_plural: false)

  book.chapters.each do |chapter|
    BakeNonIntroductionPages.v1(chapter: chapter)
    BakeLearningObjectives.v2(chapter: chapter, add_title: false, li_numbering: :count_only_li)

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}")
    end

    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}")
    end

    chapter.pages.each do |page|
      BakeAllNumberedExerciseTypes.v1(
        within: page.search('section.knowledge-check'),
        question_options: { add_dot: true }
      )
    end

    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      container_key: 'chapter-summary',
      uuid_key: '.chapter-summary',
      section_selector: 'section.chapter-summary'
    ) do |section|
      RemoveSectionTitle.v1(section: section)
    end

    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata)

    eoc_sections = %w[marketing-discussion critical-thinking building-brand
                      marketers-do marketing-plan company-case]

    eoc_sections.each do |section_key|
      BakeAllNumberedExerciseTypes.v1(
        within: chapter.pages.search("section.#{section_key}")
      )

      MoveCustomSectionToEocContainer.v1(
        chapter: chapter,
        metadata_source: metadata,
        container_key: section_key,
        uuid_key: ".#{section_key}",
        section_selector: "section.#{section_key}"
      ) do |section|
        RemoveSectionTitle.v1(section: section, selector: 'h3')
      end
    end

    BakeChapterReferences.v2(
      chapter: chapter,
      metadata_source: metadata,
      uuid_prefix: '.',
      klass: 'references'
    )

    answer_key_inner_container = AnswerKeyInnerContainer.v1(
      chapter: chapter, metadata_source: metadata, append_to: answer_key,
      options: { solutions_plural: false }
    )
    chapter.non_introduction_pages.each do |page|
      number = "#{chapter.count_in(:book)}.#{page.count_in(:chapter)}"
      Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
        within: page, append_to: answer_key_inner_container, section_class: 'knowledge-check',
        title_number: number
      )
    end
  end

  notes = %w[marketing-practice companies-conscience link-to-learning careers-marketing]
  BakeAutotitledNotes.v1(book: book, classes: notes)
  BakeAutotitledNotes.v1(
    book: book,
    classes: %w[marketing-dashboard],
    options: { bake_exercises: true }
  )
  BakeCustomTitledNotes.v1(book: book, classes: %w[unit-opener word-document])

  book.pages('$.appendix').each do |page|
    appendix_letter = [*('A'..'Z')][page.count_in(:book) - 1]
    BakeAppendix.v1(page: page, number: appendix_letter)

    page.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{appendix_letter}#{figure.count_in(:page)}")
    end

    BakeLearningObjectives.v2(
      chapter: page, add_title: false, li_numbering: :count_only_li_in_appendix
    )

    feature_sections_selectors = %w[references chapter-summary knowledge-check]
    feature_sections_selectors.each do |selector|
      page.search("section.#{selector}").each do |section|
        BakeAppendixFeatureTitles.v1(section: section, selector: selector)
      end
    end

    page.search('section.knowledge-check').injected_exercises.each do |exercise|
      BakeInjectedExercise.v1(exercise: exercise)
    end

    page.search('section.knowledge-check').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(
        question: question,
        number: "#{appendix_letter}#{question.count_in(:page)}"
      )
    end

    answer_key_appendix_inner_container = AnswerKeyInnerContainer.v1(
      chapter: page, metadata_source: metadata, append_to: answer_key,
      options: { solutions_plural: false, in_appendix: true }
    )
    Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
      within: page, append_to: answer_key_appendix_inner_container,
      section_class: 'knowledge-check', options: { in_appendix: true }
    )
  end

  BakeEquations.v1(book: book)
  BakeIframes.v1(book: book)
  BakeFootnotes.v1(book: book, number_format: :roman)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeUnitTitle.v1(book: book)
  BakeUnitPageTitle.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeRexWrappers.v1(book: book)
end
