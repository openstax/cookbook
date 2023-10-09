# frozen_string_literal: true

PL_MARKETING_RECIPE = Kitchen::BookRecipe.new(book_short_name: :plmarketing) do |doc, resources|
  include Kitchen::Directions

  # Set overrides
  doc.selectors.override(
    reference: 'section.references'
  )

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  BakeListsWithPara.v1(book: book)
  BakeImages.v1(book: book, resources: resources)
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

    BakeChapterReferences.v2(
      chapter: chapter,
      metadata_source: metadata,
      uuid_prefix: '.',
      klass: 'references'
    )

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

  notes = %w[marketing-practice companies-conscience link-to-learning careers-marketing]
  BakeAutotitledNotes.v1(book: book, classes: notes, options: { cases: true })
  BakeAutotitledNotes.v1(
    book: book,
    classes: %w[marketing-dashboard],
    options: { bake_exercises: true, cases: true }
  )

  BakeEquations.v1(book: book)
  BakeIframes.v1(book: book)
  BakeFootnotes.v1(book: book, number_format: :roman)
  BakeIndex.v1(book: book, types: %w[name term foreign], uuid_prefix: '.')
  BakeCompositePages.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeUnitTitle.v1(book: book)
  BakeUnitPageTitle.v1(book: book)
  BakeToc.v1(book: book, options: { cases: true })
  BakeFolio.v1(book: book)
  BakeLinkPlaceholders.v1(book: book, cases: true)
end
