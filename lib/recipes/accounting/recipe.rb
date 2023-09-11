# frozen_string_literal: true

# spec input file contains test content from chapter 1 and 10 (needed for
# BakeFirstElemets in the AnswerKey) from Accounting vol2

ACCOUNTING_RECIPE = Kitchen::BookRecipe.new(book_short_name: :accounting) do |doc, resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  # Some stuff just goes away
  book.search('cnx-pi').trash

  BakeImages.v1(book: book, resources: resources)
  BakePreface.v1(book: book)

  BakeUnnumberedFigure.v1(book: book)
  BakeUnnumberedTables.v1(book: book)

  answer_key = BookAnswerKeyContainer.v1(book: book)

  BakeChapterTitle.v1(book: book)
  BakeChapterIntroductions.v2(
    book: book, options: {
      strategy: :add_objectives,
      bake_chapter_outline: true
    }
  )

  book.chapters.each do |chapter|
    BakeNonIntroductionPages.v1(chapter: chapter, options: { custom_target_label: true })
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

    eoc_sections = %w[multiple-choice
                      questions
                      exercise-set-a
                      exercise-set-b
                      problem-set-a
                      problem-set-b
                      thought-provokers]

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
      chapter.composite_pages.each do |composite_page|
        composite_page.search("section.#{section_key}").exercises.each do |exercise|
          BakeNumberedExercise.v1(exercise: exercise,
                                  number: exercise.count_in(:composite_page))
          BakeFirstElements.v1(within: exercise)
        end
      end
    end

    eoc_sections_prefixed = %w[exercise-set-a
                               exercise-set-b
                               problem-set-a
                               problem-set-b
                               thought-provokers]

    BakeExercisePrefixes.v1(
      chapter: chapter,
      sections_prefixed: eoc_sections_prefixed
    )

    answer_key_inner_container = AnswerKeyInnerContainer.v1(
      chapter: chapter, metadata_source: metadata, append_to: answer_key
    )
    answer_key_classes_to_move = %w[multiple-choice questions]
    answer_key_classes_to_move.each do |klass|
      Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
        within: chapter, append_to: answer_key_inner_container, section_class: klass
      )
    end
  end

  BakeAutotitledNotes.v1(book: book, classes: %w[your-turn
                                                 think-through
                                                 concepts-practice
                                                 continuing-application
                                                 ethical-considerations
                                                 ifrs-connection
                                                 link-to-learning])

  BakeStepwise.v1(book: book)
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

  BakeEquations.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeLOLinkLabels.v1(book: book)
  BakeToc.v1(book: book)
  BakeFolio.v1(book: book)
  BakeLinks.v1(book: book)
end
