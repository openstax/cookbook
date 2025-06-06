# frozen_string_literal: true

FINANCE_RECIPE = Kitchen::BookRecipe.new(book_short_name: :finance) do |doc, _resources|
  include Kitchen::Directions

  # Set overrides
  doc.selectors.override(
    page_summary: 'section.section-summary'
  )

  book = doc.book
  metadata = book.metadata

  # Some stuff just goes away
  book.search('cnx-pi').trash

  BakeUnnumberedFigure.v1(book: book)
  BakePreface.v1(book: book, title_element: 'h1')

  book.pages('$.preface').each do |page|
    page.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: table.count_in(:page).to_s)
    end
  end

  BakeChapterIntroductions.v1(book: book)
  BakeChapterTitle.v1(book: book)

  BakeAutotitledNotes.v1(
    book: book,
    classes: %w[think-through link-to-learning concepts-practice]
  )

  BakeNumberedNotes.v1(
    book: book,
    classes: %w[cfa-institute]
  )

  BakeCustomTitledNotes.v1(book: book, classes: %w[excel-spreadsheet])

  book.chapters.each do |chapter|
    BakeLearningObjectives.v1(chapter: chapter)
    BakeNonIntroductionPages.v1(chapter: chapter)
    BakeChapterSummary.v1(chapter: chapter, metadata_source: metadata, klass: 'section-summary')
    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata)

    eoc_sections = %w[multiple-choice review-questions problem-set video-activity]

    eoc_sections.each do |klass|
      chapter.pages.search("section.#{klass}").injected_questions.each do |question|
        BakeInjectedExerciseQuestion.v1(question: question, number: question.count_in(:chapter))
      end
    end

    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      container_key: 'cfa-institute',
      uuid_key: '.cfa-institute',
      section_selector: 'section.cfa-institute'
    ) do |section|
      RemoveSectionTitle.v1(section: section)
    end

    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      container_key: 'sources-notes',
      uuid_key: '.sources-notes',
      section_selector: 'section.sources-notes'
    ) do |section|
      RemoveSectionTitle.v1(section: section)
      title = EocSectionTitleLinkSnippet.v1(page: section.ancestor(:page))
      section.prepend(child: title)
    end

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

    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}")
    end

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}")
    end
  end

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

  BakeIframes.v1(book: book)
  BakeEquations.v1(book: book)
  BakeStepwise.v1(book: book)
  BakeUnnumberedTables.v1(book: book)
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
