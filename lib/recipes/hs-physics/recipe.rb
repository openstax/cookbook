# frozen_string_literal: true

HS_PHYSICS_RECIPE = Kitchen::BookRecipe.new(book_short_name: :hs_physics) do |doc, _resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  BakeUnnumberedFigure.v1(book: book)
  BakePreface.v1(book: book)
  BakeChapterTitle.v1(book: book)
  BakeChapterIntroductions.v1(book: book)
  AddInjectedExerciseId.v1(book: book)

  BakeAutotitledNotes.v1(
    book: book,
    classes: %w[os-teacher
                boundless-physics
                worked-example
                virtual-physics
                snap-lab
                links-to-physics
                tips-for-success
                teacher-demonstration
                watch-physics
                work-in-physics
                fun-in-physics
                misconception]
  )
  BakeAutotitledNotes.v1(
    book: book,
    classes: %w[learning-objectives],
    options: { bake_subtitle: false }
  )
  book.exercises('$.grasp-check').each do |exercise|
    BakeAutotitledExercise.v2(exercise: exercise, title: I18n.t(:'grasp-check'))
  end
  BakeUnclassifiedNotes.v1(book: book)
  book.notes('$.worked-example').exercises.each do |exercise|
    exercise.add_class('unnumbered')
  end
  book.exercises('$.unnumbered').each do |exercise|
    next if exercise.has_class?('grasp-check')

    BakeUnnumberedExercise.v1(exercise: exercise)
  end

  book.chapters.each do |chapter|
    BakeNonIntroductionPages.v1(chapter: chapter)
    # Check Your Understanding + Practice Problems sections come last in a chapter section
    BakeAllNumberedExerciseTypes.v1(
      within: chapter.search('section.check-understanding, section.practice-problems'),
      exercise_options: { solution_stays_put: true }
    )

    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata)
    BakeChapterSummary.v1(chapter: chapter, metadata_source: metadata)
    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      container_key: 'key-equations',
      uuid_key: '.key-equations',
      section_selector: 'section.key-equations'
    ) do |section|
      RemoveSectionTitle.v1(section: section)
      title = EocSectionTitleLinkSnippet.v1(page: section.ancestor(:page))
      section.prepend(child: title)
    end
    chapter_review_container = ChapterReviewContainer.v1(
      chapter: chapter, metadata_source: metadata
    )
    cr_section_keys = %w[concept critical-thinking problems performance]
    cr_section_keys.each do |section_key|
      MoveCustomSectionToEocContainer.v1(
        chapter: chapter,
        metadata_source: metadata,
        container_key: section_key,
        uuid_key: ".#{section_key}",
        section_selector: "section.#{section_key}",
        append_to: chapter_review_container,
        wrap_section: true, wrap_content: true
      ) do |section|
        RemoveSectionTitle.v1(section: section)
        title = EocSectionTitleLinkSnippet.v1(page: section.ancestor(:page), title_tag: 'h4')
        section.prepend(child: title)
      end
    end
    test_prep_container = ChapterReviewContainer.v1(
      chapter: chapter, metadata_source: metadata, klass: 'test-prep'
    )
    tp_section_keys = %w[multiple-choice short-answer extended-response]
    tp_section_keys.each do |section_key|
      MoveCustomSectionToEocContainer.v1(
        chapter: chapter,
        metadata_source: metadata,
        container_key: section_key,
        uuid_key: ".#{section_key}",
        section_selector: "section.#{section_key}",
        append_to: test_prep_container,
        wrap_section: true, wrap_content: true
      ) do |section|
        RemoveSectionTitle.v1(section: section)
        title = EocSectionTitleLinkSnippet.v1(page: section.ancestor(:page), title_tag: 'h4')
        section.prepend(child: title)
      end
    end
    BakeAllNumberedExerciseTypes.v1(
      within: chapter.search('div[data-type="composite-chapter"]'),
      exercise_options: { suppress_solution_if: true }
    )
    BakeFirstElements.v1(within: chapter.search('div[data-type="composite-chapter"]').exercises)

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(
        figure: figure,
        number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}"
      )
    end
    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(
        table: table,
        number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}"
      )
    end
  end

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

  BakeUnnumberedTables.v1(book: book)
  BakeEquations.v1(book: book)
  BakeMathInParagraph.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeIframes.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeToc.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeFolio.v1(book: book)
  BakeRexWrappers.v1(book: book)
  BakeLinks.v1(book: book)
end
