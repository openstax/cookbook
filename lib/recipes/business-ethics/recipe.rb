# frozen_string_literal: true

BUSINESS_ETHICS_RECIPE = Kitchen::BookRecipe.new(book_short_name: :business_ethics) \
do |doc, _resources|
  include Kitchen::Directions

  # Set overrides
  doc.selectors.override(
    reference: 'section.references'
  )

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  BakePreface.v1(book: book)
  BakeUnnumberedFigure.v1(book: book)
  BakeUnclassifiedNotes.v1(book: book)
  BakeIframes.v1(book: book)

  BakeChapterTitle.v1(book: book)

  BakeChapterIntroductions.v2(
    book: book, options: {
      strategy: :add_objectives, bake_chapter_outline: true
    }
  )

  AddInjectedExerciseId.v1(book: book)
  book.injected_exercises.each do |exercise|
    BakeInjectedExercise.v1(exercise: exercise)
  end

  answer_key = BookAnswerKeyContainer.v1(book: book, solutions_plural: false)

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

    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata)

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

    eoc_sections = %w[assessment-questions]
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

    BakeChapterReferences.v2(
      chapter: chapter,
      metadata_source: metadata,
      uuid_prefix: '.',
      klass: 'references'
    )

    # Does BakeInjectedExerciseQuestion
    BakeAllNumberedExerciseTypes.v1(
      within: chapter.search('div[data-type="composite-page"], div[data-type="page"]')
    )

    answer_key_inner_container = AnswerKeyInnerContainer.v1(
      chapter: chapter, metadata_source: metadata, append_to: answer_key,
      options: { solutions_plural: false }
    )

    DefaultStrategyForAnswerKeySolutions.v1(
      strategy_options: { selectors: ['section.assessment-questions'] },
      chapter: chapter,
      append_to: answer_key_inner_container
    )

    answer_key_inner_container = AnswerKeyInnerContainer.v1(
      chapter: chapter, metadata_source: metadata, append_to: answer_key
    )

    classes = %w[assessment-questions]
    classes.each do |klass|
      MoveSolutionsFromExerciseSection.v1(
        within: chapter, append_to: answer_key_inner_container, section_class: klass
      )
    end
  end

  notes = %w[link-to-learning ethics-across real-world what-would]
  BakeAutotitledNotes.v1(book: book, classes: notes)

  book.pages('$.appendix').each do |page|
    appendix_letter = [*('A'..'Z')][page.count_in(:book) - 1]
    BakeAppendix.v1(page: page, number: appendix_letter)

    page.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{appendix_letter}#{figure.count_in(:page)}")
    end
  end

  AnswerKeyCleaner.v1(book: book)
  BakeFootnotes.v1(book: book, number_format: :roman)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeRexWrappers.v1(book: book)
  BakeLinks.v1(book: book)
end
