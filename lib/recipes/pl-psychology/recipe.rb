# frozen_string_literal: true

PL_PSYCHOLOGY_RECIPE = Kitchen::BookRecipe.new(book_short_name: :plpsychology) do |doc, _resources|
  include Kitchen::Directions

  # Set overrides
  doc.selectors.override(
    reference: 'section.references'
  )

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  BakeListsWithPara.v1(book: book)

  BakePreface.v1(book: book)
  BakeUnnumberedFigure.v1(book: book)

  BakeChapterIntroductions.v2(
    book: book, options: {
      strategy: :add_objectives, bake_chapter_outline: true, block_target_label: true, cases: true
    }
  )

  BakeChapterTitle.v1(book: book, cases: true)

  book.chapters.each do |chapter|
    BakeLearningObjectives.v1(chapter: chapter)

    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v2(table: table,
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

    BakeNonIntroductionPages.v1(chapter: chapter, options: { block_target_label: true })

    BakeChapterGlossary.v1(chapter: chapter, metadata_source: book.metadata, has_para: true)

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

    eoc_with_exercise = %w[review-questions critical-thinking personal-application]
    eoc_with_exercise.each do |section_key|
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

    selectors = 'section.review-questions, section.critical-thinking, section.personal-application'
    chapter.search(selectors).exercises.each do |exercise|
      BakeNumberedExercise.v1(
        exercise: exercise, number: exercise.count_in(:chapter),
        options: { suppress_solution_if: true, cases: true }
      )
    end
  end

  notes = %w[link-to-learning dig-deeper everyday-connection what-do-you-think connect-the-concepts]
  BakeAutotitledNotes.v1(book: book, classes: notes, options: { cases: true })

  BakeReferences.v2(book: book, metadata_source: book.metadata)
  BakeIndex.v1(book: book, types: %w[name term foreign], uuid_prefix: '.')
  BakeCompositePages.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeToc.v1(book: book, options: { cases: true })
  BakeLinkPlaceholders.v1(book: book, cases: true)
  BakeFolio.v1(book: book)
  BakeLinks.v1(book: book)
  BakeRexWrappers.v1(book: book)
end
