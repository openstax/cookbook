# frozen_string_literal: true

ENTREPRENEURSHIP_RECIPE = Kitchen::BookRecipe.new(book_short_name: :entrepreneurship) \
do |doc, _resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  BakeUnnumberedFigure.v1(book: book)
  BakePreface.v1(book: book)
  BakeChapterTitle.v1(book: book)
  BakeChapterIntroductions.v1(book: book)

  BakeAutotitledNotes.v1(
    book: book,
    classes: %w[
      are-you-ready
      what-can-do
      link-to-learning
      entrepreneur-in-action
      work-it-out
    ]
  )

  book.chapters.each do |chapter|
    BakeNonIntroductionPages.v1(chapter: chapter)

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
    eoc_sections = %w[review-questions discussion-questions case-questions]
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
      chapter.sections("$.#{section_key}").exercises.each do |exercise|
        BakeNumberedExercise.v1(exercise: exercise, number: exercise.count_in(:chapter))
      end
    end
    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      container_key: 'suggested-resources',
      uuid_key: '.suggested-resources',
      section_selector: 'section.suggested-resources'
    ) do |section|
      RemoveSectionTitle.v1(section: section)
      title = EocSectionTitleLinkSnippet.v1(page: section.ancestor(:page))
      section.prepend(child: title)
    end

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(
        figure: figure,
        number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}"
      )
    end

    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v2(
        table: table,
        number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}"
      )
    end
  end

  book.pages('$.appendix').each do |page|
    appendix_letter = [*('A'..'Z')][page.count_in(:book) - 1]
    BakeAppendix.v1(page: page, number: appendix_letter)
  end

  BakeFootnotes.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeRexWrappers.v1(book: book)
  BakeLinks.v1(book: book)
end
