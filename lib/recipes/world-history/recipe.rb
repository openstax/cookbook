# frozen_string_literal: true

WORLD_HISTORY_RECIPE = Kitchen::BookRecipe.new(book_short_name: :world_history) do |doc, _resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  # Some stuff just goes away
  book.search('cnx-pi').trash

  AddInjectedExerciseId.v1(book: book)
  book.injected_exercises.each do |exercise|
    BakeInjectedExercise.v1(exercise: exercise)
  end

  BakePreface.v1(book: book)
  BakeUnnumberedFigure.v1(book: book)

  BakeChapterTitle.v1(book: book)
  BakeChapterIntroductions.v2(
    book: book, options: {
      strategy: :add_objectives,
      bake_chapter_outline: true
    }
  )

  BakeUnitTitle.v1(book: book)

  book.chapters.each do |chapter|

    # Eoc sections
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

    eoc_wrapper = ChapterReviewContainer.v1(
      chapter: chapter, metadata_source: metadata, klass: 'assessments'
    )

    eoc_sections = %w[review-questions
                      check-understanding
                      reflection-questions
                      visual-questions
                      making-connections
                      thought-provokers
                      source-questions]

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
    end

    # Bake both kinds of exercise
    chapter.composite_pages.search_with(Kitchen::ExerciseElementEnumerator,
                                        Kitchen::InjectedQuestionElementEnumerator)
           .each do |exercise|
      if exercise.instance_of?(Kitchen::ExerciseElement)
        BakeNumberedExercise.v1(
          exercise: exercise, number: exercise.count_in(:composite_page),
          options: { suppress_solution_if: true }
        )
      else
        BakeInjectedExerciseQuestion.v1(question: exercise,
                                        number: exercise.count_in(:composite_page))
      end
    end

    BakeLearningObjectives.v1(chapter: chapter)
    BakeNonIntroductionPages.v1(chapter: chapter)

    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}")
    end

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(
        figure: figure,
        number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}"
      )
    end
  end

  BakeAutotitledNotes.v1(book: book, classes: %w[own-words
                                                 dueling-voices
                                                 beyond-book
                                                 past-present])

  BakeAutotitledNotes.v1(
    book: book,
    classes: %w[link-to-learning],
    options: { bake_subtitle: false }
  )

  BakeStepwise.v1(book: book)
  BakeUnnumberedTables.v1(book: book)
  book.pages('$.appendix').each do |page|
    appendix_letter = [*('A'..'Z')][page.count_in(:book) - 1]
    BakeAppendix.v1(page: page, number: appendix_letter)

    page.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{appendix_letter}#{figure.count_in(:page)}")
    end
    page.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{appendix_letter}#{table.count_in(:page)}")
    end
  end

  BakeIframes.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeToc.v1(book: book)
  BakeFolio.v1(book: book)
  BakeRexWrappers.v1(book: book)
  BakeLinks.v1(book: book)
end
