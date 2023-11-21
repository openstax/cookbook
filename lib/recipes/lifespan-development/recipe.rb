# frozen_string_literal: true

LIFESPAN_DEVELOPMENT_RECIPE = Kitchen::BookRecipe.new(book_short_name: :lifespan_development) \
do |doc, _resources|
  include Kitchen::Directions

  # Set overrides
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
      exercise: exercise
    )
  end

  BakeChapterTitle.v1(book: book)
  BakeChapterIntroductions.v1(book: book)

  book.chapters.each do |chapter|
    BakeNonIntroductionPages.v1(chapter: chapter)

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}")
    end

    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v2(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}")
    end

    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata)

    sections_with_module_links = %w[summary references]

    sections_with_module_links.each do |eoc_section|
      MoveCustomSectionToEocContainer.v1(
        chapter: chapter,
        metadata_source: metadata,
        container_key: eoc_section,
        uuid_key: ".#{eoc_section}",
        section_selector: "section.#{eoc_section}"
      ) do |section|
        RemoveSectionTitle.v1(section: section)
        title = EocSectionTitleLinkSnippet.v1(page: section.ancestor(:page))
        section.prepend(child: title)
      end
    end

    sections_with_exercises = %w[review-questions check-understanding reflection-questions
                                 media-questions thought-provokers case-study]

    sections_with_exercises.each do |section_key|
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

    BakeAllNumberedExerciseTypes.v1(
      within: chapter.search('div[data-type="composite-page"]')
    )
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

  BakeFootnotes.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeRexWrappers.v1(book: book)
  BakeLinks.v1(book: book)
end
