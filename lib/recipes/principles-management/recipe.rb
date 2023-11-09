# frozen_string_literal: true

PRINCIPLES_MANAGEMENT_RECIPE = Kitchen::BookRecipe.new(book_short_name: :principles_management) \
do |doc, _resources|
  include Kitchen::Directions

  # Set overrides
  doc.selectors.override(
    page_summary: 'section.section-summary'
  )

  book = doc.book
  metadata = book.metadata

  # Some stuff just goes away
  book.search('cnx-pi').trash

  BakePreface.v1(book: book, title_element: 'h1')
  BakeChapterIntroductions.v2(book: book)
  BakeChapterTitle.v1(book: book)

  BakeAutotitledNotes.v1(
    book: book,
    classes: %w[exploring-manager-careers concept-check
                sustainability-responsible managerial-leadership
                ethics-in-practice managing-change
                catching-spirit expanding-around-globe customer-satisfaction]
  )

  BakeReferences.v1(book: book, metadata_source: metadata)

  book.chapters.each do |chapter|
    BakeLearningObjectives.v1(chapter: chapter)
    BakeNonIntroductionPages.v1(chapter: chapter)
    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata)
    BakeChapterSummary.v1(chapter: chapter, metadata_source: metadata, klass: 'section-summary')

    BakeChapterReferences.v1(chapter: chapter, metadata_source: metadata)

    eoc_sections = %w[section-summary chapter-review manage-skills
                      manage-exercises critical-thinking]

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

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}")
    end

    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v2(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}")
    end
  end

  BakeUnnumberedFigure.v1(book: book)
  BakeUnnumberedTables.v1(book: book)

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

  BakeMathInParagraph.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeRexWrappers.v1(book: book)
  BakeLinks.v1(book: book)
end
