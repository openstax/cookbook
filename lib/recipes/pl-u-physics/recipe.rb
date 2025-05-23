# frozen_string_literal: true

PL_U_PHYSICS_RECIPE = Kitchen::BookRecipe.new(book_short_name: :pluphysics) do |doc, _resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash
  book.search('.check-understanding strong').trash

  BakePreface.v1(book: book)

  BakeChapterTitle.v1(book: book, cases: true)
  BakeUnitTitle.v1(book: book)

  BakeUnnumberedFigure.v1(book: book)
  BakeUnnumberedTables.v1(book: book)

  BakeChapterIntroductions.v2(
    book: book, options: {
      strategy: :add_objectives,
      bake_chapter_outline: true,
      block_target_label: true,
      cases: true
    }
  )

  # Notes
  notes = %w[media-2 problem-solving]
  BakeAutotitledNotes.v1(book: book, classes: notes, options: { cases: true })
  BakeUnclassifiedNotes.v1(book: book)
  BakeNumberedNotes.v1(book: book, classes: %w[check-understanding], options: { cases: true })

  solutions_container = BookAnswerKeyContainer.v1(book: book)

  book.chapters.each do |chapter|
    BakeNonIntroductionPages.v1(chapter: chapter, options: { cases: true })
    BakeLearningObjectives.v1(chapter: chapter)

    # EOC
    eoc_wrapper = ChapterReviewContainer.v1(chapter: chapter, metadata_source: metadata)

    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata, append_to: eoc_wrapper)

    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      container_key: 'key-equations',
      uuid_key: '.key-equations',
      section_selector: 'section.key-equations',
      append_to: eoc_wrapper
    ) do |section|
      RemoveSectionTitle.v1(section: section)
    end

    sections_with_links = %w[key-concepts review-conceptual-questions review-problems]

    sections_with_links.each do |section_key|
      MoveCustomSectionToEocContainer.v1(
        chapter: chapter,
        metadata_source: metadata,
        container_key: section_key,
        uuid_key: ".#{section_key}",
        section_selector: "section.#{section_key}",
        append_to: eoc_wrapper,
        wrap_section: true, wrap_content: true
      ) do |section|
        RemoveSectionTitle.v1(section: section)
        title = EocSectionTitleLinkSnippet.v1(page: section.ancestor(:page), title_tag: 'h4')
        section.prepend(child: title)
      end
    end

    sections_without_links = %w[review-additional-problems review-challenge]
    sections_without_links.each do |section_key|
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

    exercise_selectors = 'section.review-conceptual-questions, section.review-problems, ' \
                         'section.review-additional-problems, section.review-challenge'
    chapter.search(exercise_selectors).exercises.each do |exercise|
      BakeNumberedExercise.v1(
        exercise: exercise, number: exercise.count_in(:chapter),
        options: { cases: true }
      )
    end

    answer_key_inner_container = AnswerKeyInnerContainer.v1(
      chapter: chapter, metadata_source: metadata, append_to: solutions_container,
      options: { cases: true }
    )
    Kitchen::Directions::MoveSolutionsFromNumberedNote.v1(
      chapter: chapter, append_to: answer_key_inner_container, note_class: 'check-understanding'
    )
    exercise_section_classes = %w[review-conceptual-questions review-problems
                                  review-additional-problems review-challenge]
    exercise_section_classes.each do |klass|
      Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
        within: chapter, append_to: answer_key_inner_container, section_class: klass
      )
    end
  end

  book.search('div[data-type="solution"]').each do |solution|
    BakeFirstElements.v1(within: solution)
  end

  book.search('div[data-type="problem"]').each do |problem|
    BakeFirstElements.v1(within: problem)
  end

  book.chapters.each do |chapter|
    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}",
                           cases: true)
    end

    chapter.examples.each do |example|
      BakeExample.v1(example: example,
                     number: "#{chapter.count_in(:book)}.#{example.count_in(:chapter)}",
                     title_tag: 'h3',
                     options: { cases: true })
    end

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}",
                    cases: true)
    end
  end

  book.pages('$.appendix').each do |page|
    appendix_letter = [*('A'..'Z')][page.count_in(:book) - 1]
    BakeAppendix.v1(page: page,
                    number: appendix_letter,
                    options: {
                      block_target_label: true,
                      cases: true
                    }
    )

    page.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{appendix_letter}#{table.count_in(:page)}",
                           cases: true)
    end
  end

  BakeIframes.v1(book: book)
  BakeEquations.v1(book: book, cases: true)
  BakeMathInParagraph.v1(book: book)
  BakeIndex.v1(book: book, types: %w[name term foreign], uuid_prefix: '.')
  BakeCompositePages.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeToc.v1(book: book, options: { cases: true })
  BakeLinkPlaceholders.v1(book: book, cases: true)
  BakeFolio.v1(book: book)
  BakeLinks.v1(book: book)
  BakeRexWrappers.v1(book: book)
end
