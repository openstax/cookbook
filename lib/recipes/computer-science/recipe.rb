# frozen_string_literal: true

COMPUTER_SCIENCE_RECIPE = Kitchen::BookRecipe.new(book_short_name: :computer_science) \
do |doc, resources|
  include Kitchen::Directions

  # Set overrides
  doc.selectors.override(
    page_summary: 'section.section-summary'
  )

  book = doc.book
  metadata = book.metadata

  # Some stuff just goes away
  book.search('cnx-pi').trash

  BakeImages.v1(book: book, resources: resources)
  BakeUnnumberedFigure.v1(book: book)
  BakePreface.v1(book: book, title_element: 'h1')
  BakeChapterIntroductions.v1(book: book)
  AddInjectedExerciseId.v1(book: book)
  book.injected_exercises.each do |exercise|
    BakeInjectedExercise.v1(exercise: exercise)
  end
  BakeChapterTitle.v1(book: book)
  BakeUnitTitle.v1(book: book)
  BakeUnitPageTitle.v1(book: book)

  BakeAutotitledNotes.v1(
    book: book,
    classes: %w[concepts-practice tech-everyday global-tech link-to-learning industry-spotlight]
  )

  BakeAutotitledNotes.v1(
    book: book,
    classes: %w[think-through],
    options: { bake_exercises: true }
  )

  BakeUnclassifiedNotes.v1(book: book)

  book.chapters.each do |chapter|
    BakeLearningObjectives.v2(chapter: chapter, add_title: false)
    BakeNonIntroductionPages.v1(chapter: chapter)

    # create Chapter Review EOC wrapper
    eoc_wrapper = ChapterReviewContainer.v1(chapter: chapter, metadata_source: metadata)
    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata, append_to: eoc_wrapper)
    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      container_key: 'section-summary',
      uuid_key: '.section-summary',
      section_selector: 'section.section-summary',
      append_to: eoc_wrapper
    ) do |section|
      RemoveSectionTitle.v1(section: section)
      title = EocSectionTitleLinkSnippet.v1(page: section.ancestor(:page))
      section.prepend(child: title)
    end
    eoc_sections = %w[review-questions conceptual-questions practice-exercises
                      problem-set-a problem-set-b thought-provokers lab-assessments]

    eoc_sections.each do |section_key|
      MoveCustomSectionToEocContainer.v1(
        chapter: chapter,
        metadata_source: metadata,
        container_key: section_key,
        uuid_key: ".#{section_key}",
        section_selector: "section.#{section_key}",
        append_to: eoc_wrapper
      ) do |section|
        RemoveSectionTitle.v1(section: section)
      end
      chapter.composite_pages.search("section.#{section_key}").injected_questions.each do |question|
        BakeInjectedExerciseQuestion.v1(
          question: question, number: question.count_in(:composite_page)
        )
      end
    end

    chapter.exercises('$.your-turn').each do |exercise|
      BakeAutotitledExercise.v1(exercise: exercise)
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
  BakeLinks.v1(book: book)
end