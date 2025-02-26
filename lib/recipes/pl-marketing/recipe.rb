# frozen_string_literal: true

PL_MARKETING_RECIPE = Kitchen::BookRecipe.new(book_short_name: :plmarketing) do |doc, _resources|
  include Kitchen::Directions

  # Set overrides
  doc.selectors.override(
    reference: 'aside.reference'
  )

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  BakeListsWithPara.v1(book: book)
  BakePreface.v1(book: book, cases: true)

  book.pages('$.preface').each do |page|
    page.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: table.count_in(:page).to_s,
                           cases: true)
    end
  end

  BakeChapterIntroductions.v2(
    book: book, options: {
      strategy: :add_objectives, bake_chapter_outline: true, introduction_order: :v3, cases: true
    }
  )
  BakeChapterTitle.v1(book: book, cases: true)

  BakeUnnumberedFigure.v1(book: book)
  BakeUnclassifiedNotes.v1(book: book)

  answer_key = BookAnswerKeyContainer.v1(book: book, solutions_plural: false)

  book.chapters.each do |chapter|
    BakeNonIntroductionPages.v1(chapter: chapter, options: { cases: true })
    BakeLearningObjectives.v2(chapter: chapter, add_title: false, li_numbering: :count_only_li)

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

    chapter.pages.each do |page|
      BakeAllNumberedExerciseTypes.v1(
        within: page.search('section.knowledge-check'),
        exercise_options: { cases: true },
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

    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata, has_para: true)

    eoc_sections = %w[marketing-discussion critical-thinking marketing-plan company-case]

    eoc_sections.each do |section_key|
      BakeAllNumberedExerciseTypes.v1(
        within: chapter.pages.search("section.#{section_key}"),
        exercise_options: { cases: true }
      )

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

    answer_key_inner_container = AnswerKeyInnerContainer.v1(
      chapter: chapter, metadata_source: metadata, append_to: answer_key,
      options: { solutions_plural: false, cases: true }
    )
    chapter.non_introduction_pages.each do |page|
      number = "#{chapter.count_in(:book)}.#{page.count_in(:chapter)}"
      Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
        within: page, append_to: answer_key_inner_container, section_class: 'knowledge-check',
        title_number: number
      )
    end
  end

  # References
  BakeFootnotes.v1(book: book, selector: '.reference')

  book.chapters.each do |chapter|
    BakeChapterReferences.v4(
      chapter: chapter,
      metadata_source: metadata,
      klass: 'references'
    )
  end

  # Notes
  notes = %w[marketing-practice companies-conscience link-to-learning]
  BakeAutotitledNotes.v1(book: book, classes: notes, options: { cases: true })
  BakeAutotitledNotes.v1(
    book: book,
    classes: %w[marketing-dashboard],
    options: { bake_exercises: true, cases: true }
  )

  BakeEquations.v1(book: book)
  BakeIframes.v1(book: book)
  BakeFootnotes.v1(book: book, number_format: :roman, selector: ':not(.reference)')
  BakeIndex.v1(book: book, types: %w[name term foreign], uuid_prefix: '.')
  BakeCompositePages.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeUnitTitle.v1(book: book)
  BakeUnitPageTitle.v1(book: book)
  BakeToc.v1(book: book, options: { cases: true })
  BakeFolio.v1(book: book)
  BakeRexWrappers.v1(book: book)
  BakeLinkPlaceholders.v1(book: book, cases: true)
end
