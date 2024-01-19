# frozen_string_literal: true

INFORMATION_SYSTEMS_RECIPE = Kitchen::BookRecipe.new(book_short_name: :info_sys) \
do |doc, _resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  BakePreface.v1(book: book)
  BakeUnnumberedFigure.v1(book: book)
  BakeUnnumberedTables.v1(book: book)

  AddInjectedExerciseId.v1(book: book)
  book.injected_exercises.each do |exercise|
    BakeInjectedExercise.v1(exercise: exercise)
  end

  BakeUnitTitle.v1(book: book)
  BakeChapterTitle.v1(book: book)
  BakeChapterIntroductions.v1(book: book)

  BakeAutotitledNotes.v1(
    book: book,
    classes: %w[future-tech global-connect is-ethics is-careers link-to-learning]
  )

  answer_key = BookAnswerKeyContainer.v1(book: book)

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

    # EOC
    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata)

    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      container_key: 'summary',
      uuid_key: '.summary',
      section_selector: 'section.summary'
    ) do |section|
      RemoveSectionTitle.v1(section: section)
      title = EocSectionTitleLinkSnippet.v1(page: section.ancestor(:page))
      section.prepend(child: title)
    end

    eoc_sections = %w[review-questions check-understanding
                      reflection-questions media-questions]

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

      chapter.composite_pages.search("section.#{section_key}").injected_questions.each do |question|
        BakeInjectedExerciseQuestion.v1(
          question: question, number: question.count_in(:composite_page)
        )
        BakeFirstElements.v1(within: question)
      end
    end

    # Answer Key
    answer_key_inner_container = AnswerKeyInnerContainer.v1(
      chapter: chapter, metadata_source: metadata, append_to: answer_key
    )

    eoc_sections.each do |klass|
      Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
        within: chapter, append_to: answer_key_inner_container, section_class: klass
      )
    end
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

  BakeTableColumns.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeRexWrappers.v1(book: book)
  BakeLinks.v1(book: book)
end
