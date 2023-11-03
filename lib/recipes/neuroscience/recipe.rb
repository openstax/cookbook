# frozen_string_literal: true

NEUROSCIENCE_RECIPE = Kitchen::BookRecipe.new(book_short_name: :neuroscience) do |doc, _resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  BakeUnnumberedFigure.v1(book: book)
  BakePreface.v1(book: book)

  AddInjectedExerciseId.v1(book: book)
  book.injected_exercises.each do |exercise|
    BakeInjectedExercise.v1(
      exercise: exercise
    )
  end

  BakeUnitTitle.v1(book: book)
  BakeChapterTitle.v1(book: book)

  book.chapters.each do |chapter|
    BakeNonIntroductionPages.v1(chapter: chapter)
    BakeLearningObjectives.v2(chapter: chapter, add_title: false)

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}")
    end

    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}")
    end

    # EOC
    sections_with_module_links = %w[section-summary key-terms references
                                    multiple-choice fillin-blank]

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

    # Exercises
    chapter.search('section.multiple-choice').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(question: question, number: question.count_in(:chapter))
      BakeFirstElements.v1(within: question)
    end

    chapter.search('section.fillin-blank').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(question: question, number: question.count_in(:chapter))
      BakeFirstElements.v1(within: question)
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

  BakeChapterIntroductions.v1(book: book)
  BakeIframes.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeIndex.v1(book: book)
  BakeFolio.v1(book: book)
  BakeRexWrappers.v1(book: book)
  BakeLinks.v1(book: book)

  book.notes('$.developmental-perspective').each { |note| note['use-subtitle'] = true }
  note_classes = %w[meet-author developmental-perspective across-species inthe-lab]
  BakeAutotitledNotes.v1(book: book, classes: note_classes)

  BakeCustomTitledNotes.v1(book: book, classes: %w[boxed-feature])
end
