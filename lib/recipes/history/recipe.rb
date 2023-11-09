# frozen_string_literal: true

HISTORY_RECIPE = Kitchen::BookRecipe.new(book_short_name: :history) do |doc, _resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  # Some stuff just goes away
  book.search('cnx-pi').trash

  BakePreface.v1(book: book, title_element: 'h1')
  BakeChapterIntroductions.v1(book: book)
  BakeChapterTitle.v1(book: book)

  BakeAutotitledNotes.v1(
    book: book,
    classes: %w[click-and-explore my-story americana defining-american]
  )

  answer_key = BookAnswerKeyContainer.v1(book: book, solutions_plural: false)

  book.chapters.each do |chapter|
    BakeLearningObjectives.v1(chapter: chapter)
    BakeNonIntroductionPages.v1(chapter: chapter)
    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata)
    BakeChapterSummary.v1(chapter: chapter, metadata_source: metadata)

    eoc_sections = %w[review-questions critical-thinking]

    chapter.search(eoc_sections.prefix('section.')).exercises.each do |exercise|
      if exercise.parent.has_class?('review-questions')
        BakeNumberedExercise.v1(
          exercise: exercise,
          number: exercise.count_in(:chapter),
          options: {
            suppress_solution_if: :even?,
            note_suppressed_solutions: true
          }
        )
      else
        BakeNumberedExercise.v1(exercise: exercise, number: exercise.count_in(:chapter))
      end
    end

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}")
    end

    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}")
    end

    answer_key_inner_container = AnswerKeyInnerContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      append_to: answer_key,
      options: { solutions_plural: false }
    )

    DefaultStrategyForAnswerKeySolutions.v1(
      strategy_options: {
        selectors: ['section.review-questions'],
        condition: :even?
      },
      chapter: chapter,
      append_to: answer_key_inner_container
    )

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

  BakeUnnumberedFigure.v1(book: book)

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
