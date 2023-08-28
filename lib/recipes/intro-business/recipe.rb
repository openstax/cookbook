# frozen_string_literal: true

INTRO_BUSINESS_RECIPE = Kitchen::BookRecipe.new(book_short_name: :intro_business) \
do |doc, resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  BakeImages.v1(book: book, resources: resources)
  BakePreface.v1(book: book)
  BakeUnnumberedFigure.v1(book: book)

  BakeChapterTitle.v1(book: book)

  BakeChapterIntroductions.v2(book: book)

  book.chapters.each do |chapter|

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}")
    end

    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v2(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}")
    end

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

    eoc_sections = %w[prep-workplace ethics-activity working-net critical-thinking hot-links]
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
  end

  notes = %w[exploring-business-careers catching-spirit concept-check
             managing-change customer-satisfaction ethics-in-practice expanding-around-globe]
  BakeAutotitledNotes.v1(book: book, classes: notes)

  book.pages('$.appendix').each do |page|
    appendix_letter = [*('A'..'Z')][page.count_in(:book) - 1]
    BakeAppendix.v1(page: page, number: appendix_letter)

    page.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v2(
        table: table,
        number: "#{appendix_letter}#{table.count_in(:page)}"
      )
    end
  end

  BakeUnnumberedTables.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeIndex.v1(book: book)
  BakeReferences.v1(book: book, metadata_source: metadata)
  BakeCompositePages.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeLinks.v1(book: book)
end



