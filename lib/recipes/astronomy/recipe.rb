# frozen_string_literal: true

ASTRONOMY_RECIPE = Kitchen::BookRecipe.new(book_short_name: :astronomy) do |doc, _resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  BakeUnnumberedFigure.v1(book: book)
  BakePreface.v1(book: book)
  BakeChapterTitle.v1(book: book)
  BakeChapterIntroductions.v1(book: book)

  BakeAutotitledNotes.v1(
    book: book,
    classes: %w[
      link-to-learning
      astronomy-basics
      making-connections
      seeing-for-yourself
      voyagers-in-astronomy
    ]
  )
  BakeUnclassifiedNotes.v1(book: book)

  book.chapters.each do |chapter|
    BakeNonIntroductionPages.v1(chapter: chapter)

    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata)
    BakeChapterSummary.v1(chapter: chapter, metadata_source: metadata)
    section_keys = %w[further-exploration group-activities]
    section_keys.each do |section_key|
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
    exercises_composite_chapter = \
      ChapterReviewContainer.v1(chapter: chapter, metadata_source: metadata, klass: 'exercises')
    exercise_section_keys = %w[review-questions thought-questions figuring-for-yourself]
    exercise_section_keys.each do |section_key|
      MoveCustomSectionToEocContainer.v1(
        chapter: chapter,
        metadata_source: metadata,
        container_key: section_key,
        uuid_key: ".#{section_key}",
        section_selector: "section.#{section_key}",
        append_to: exercises_composite_chapter
      ) do |section|
        RemoveSectionTitle.v1(section: section)
      end
    end
    exercises_composite_chapter.exercises.each do |exercise|
      BakeNumberedExercise.v1(exercise: exercise, number: exercise.count_in(:chapter))
    end
    exercises_composite_chapter.trash if exercises_composite_chapter.sections.none?

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(
        figure: figure,
        number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}"
      )
    end
    chapter.examples.each do |example|
      BakeExample.v1(
        example: example,
        number: "#{chapter.count_in(:book)}.#{example.count_in(:chapter)}",
        title_tag: 'h3'
      )
    end
    chapter.tables.each do |table|
      BakeNumberedTable.v1(
        table: table,
        number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}"
      )
    end
  end

  book.pages('$.appendix').each do |page|
    appendix_letter = [*('A'..'Z')][page.count_in(:book) - 1]
    BakeAppendix.v1(page: page, number: appendix_letter)

    page.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table, number: "#{appendix_letter}#{table.count_in(:page)}")
    end
    page.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure, number: "#{appendix_letter}#{figure.count_in(:page)}")
    end
  end

  BakeScreenreaderSpans.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeEquations.v1(book: book)
  BakeMathInParagraph.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeRexWrappers.v1(book: book)
  BakeLinks.v1(book: book)
end
