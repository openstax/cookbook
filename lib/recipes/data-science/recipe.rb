# frozen_string_literal: true

DATA_SCIENCE_RECIPE = Kitchen::BookRecipe.new(book_short_name: :data_science) \
do |doc, _resources|
  include Kitchen::Directions

  book = doc.book

  book.search('cnx-pi').trash
  metadata = book.metadata

  BakePreface.v1(book: book)
  BakeUnnumberedFigure.v1(book: book)
  BakeUnnumberedTables.v1(book: book)

  AddInjectedExerciseId.v1(book: book)
  book.injected_exercises.each do |exercise|
    BakeInjectedExercise.v1(exercise: exercise)
  end

  BakeChapterTitle.v1(book: book)
  BakeChapterIntroductions.v1(book: book)

  book.chapters.each do |chapter|
    BakeNonIntroductionPages.v1(chapter: chapter)
    BakeLearningObjectives.v2(chapter: chapter, add_title: false)

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}")
    end

    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v2(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}")
    end

    chapter.examples.each do |example|
      BakeExample.v1(example: example,
                     number: "#{chapter.count_in(:book)}.#{example.count_in(:chapter)}",
                     title_tag: 'h3')
    end

    # EOC
    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata)

    eoc_sections = %w[group-project chapter-problems]

    eoc_sections.each do |section_key|
      MoveCustomSectionToEocContainer.v1(
        chapter: chapter,
        metadata_source: metadata,
        container_key: section_key,
        uuid_key: ".#{section_key}",
        section_selector: "section.#{section_key}"
      ) do |section|
        title = EocSectionTitleLinkSnippet.v1(page: section.ancestor(:page))
        section.prepend(child: title)
      end
    end

    chapter.composite_pages.search('section.chapter-problems').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(
        question: question, number: question.count_in(:composite_page)
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

  BakeEquations.v1(book: book)
  BakeIndex.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeRexWrappers.v1(book: book)
  BakeLinks.v1(book: book)

  note_classes = %w[exploring-further python-feature]
  BakeAutotitledNotes.v1(book: book, classes: note_classes)

  BakeCustomTitledNotes.v1(book: book, classes: %w[boxed-feature download-file])
end
