# frozen_string_literal: true

# used for prealgebra, intermediate-algebra, and elementary-algebra
DEV_MATH_RECIPE = Kitchen::BookRecipe.new(book_short_name: :dev_math) do |doc, _resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  BakeUnnumberedFigure.v1(book: book)
  BakePreface.v1(book: book)
  BakeChapterTitle.v1(book: book)
  BakeChapterIntroductions.v1(book: book)

  BakeUnclassifiedNotes.v1(book: book)
  BakeNumberedNotes.v1(book: book, classes: %w[try be-prepared])
  book.notes('$.try, .be-prepared').exercises.each do |exercise|
    BakeFirstElements.v1(within: exercise, first_inline_list: true)
  end
  BakeAutotitledNotes.v1(book: book, classes: %w[manipulative-math howto media-2 links-to-literacy])

  answer_key = BookAnswerKeyContainer.v1(book: book)
  book.chapters.each do |chapter|
    BakeLearningObjectives.v1(chapter: chapter)
    BakeNonIntroductionPages.v1(chapter: chapter)

    chapter_review = ChapterReviewContainer.v1(chapter: chapter, metadata_source: metadata)
    exercises_composite_chapter = ChapterReviewContainer.v1(
      chapter: chapter, metadata_source: metadata, klass: 'exercises'
    )
    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata, append_to: chapter_review)
    MoveCustomSectionToEocContainer.v1(
      chapter: chapter, metadata_source: metadata,
      container_key: 'key-concepts', uuid_key: '.key-concepts',
      section_selector: 'section.key-concepts',
      append_to: chapter_review,
      wrap_section: true, wrap_content: true
    ) do |section|
      RemoveSectionTitle.v1(section: section)
      title = EocSectionTitleLinkSnippet.v1(page: section.ancestor(:page), title_tag: 'h4')
      section.prepend(child: title)
    end

    MoveCustomSectionToEocContainer.v1(
      chapter: chapter, metadata_source: metadata,
      container_key: 'review-exercises', uuid_key: '.review-exercises',
      section_selector: 'section.review-exercises',
      append_to: exercises_composite_chapter
    ) do |section|
      RemoveSectionTitle.v1(section: section)
      ChangeSubsectionTitleTag.v1(section: section)
    end
    MoveExercisesToEOC.v1(
      chapter: chapter, metadata_source: metadata, klass: 'practice-test',
      append_to: exercises_composite_chapter
    )
    exercise_sections = 'section.section-exercises, section.review-exercises, section.practice-test'
    chapter.search(exercise_sections).exercises.each do |exercise|
      BakeNumberedExercise.v1(exercise: exercise, number: exercise.count_in(:chapter))
      BakeFirstElements.v1(within: exercise, first_inline_list: true)
    end
    BakeChapterSectionExercises.v1(chapter: chapter)
    chapter.sections('$.section-exercises').each do |section|
      section.search(' > h3[data-type="title"]').first&.trash
    end

    # Make the answer key:
    answer_key_inner_container = AnswerKeyInnerContainer.v1(
      chapter: chapter, metadata_source: metadata, append_to: answer_key
    )
    MoveSolutionsFromNumberedNote.v1(
      chapter: chapter, append_to: answer_key_inner_container, note_class: 'be-prepared'
    )
    MoveSolutionsFromNumberedNote.v1(
      chapter: chapter, append_to: answer_key_inner_container, note_class: 'try'
    )
    chapter.non_introduction_pages.each do |page|
      number = "#{chapter.count_in(:book)}.#{page.count_in(:chapter)}"
      Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
        within: page, append_to: answer_key_inner_container, section_class: 'section-exercises',
        title_number: number
      )
    end
    exercise_section_classes = %w[review-exercises practice-test]
    exercise_section_classes.each do |klass|
      Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
        within: chapter, append_to: answer_key_inner_container, section_class: klass
      )
    end

    # Bake features
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
      example.first('div.os-solution-container')&.first('h4[data-type="title"]')&.trash
    end
    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(
        table: table,
        number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}"
      )
    end
  end

  book.examples.exercises.each do |exercise|
    BakeFirstElements.v1(within: exercise, first_inline_list: true)
  end

  book.pages('$.appendix').each do |page|
    appendix_letter = [*('A'..'Z')][page.count_in(:book) - 1]
    BakeAppendix.v1(page: page, number: appendix_letter)

    page.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table, number: "#{appendix_letter}#{table.count_in(:page)}")
    end
  end

  BakeUnnumberedTables.v1(book: book)
  BakeStepwise.v1(book: book)
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
