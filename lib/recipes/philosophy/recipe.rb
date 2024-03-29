# frozen_string_literal: true

PHILOSOPHY_RECIPE = Kitchen::BookRecipe.new(book_short_name: :philosophy) do |doc, _resources|
  include Kitchen::Directions

  # Set overrides
  doc.selectors.override(
    reference: '.references'
  )

  book = doc.book
  metadata = book.metadata

  book.search('cnx-pi').trash

  BakePreface.v1(book: book)
  BakeChapterTitle.v1(book: book)
  BakeChapterIntroductions.v2(
    book: book, options: {
      strategy: :add_objectives, bake_chapter_outline: true
    }
  )
  BakeUnnumberedFigure.v1(book: book)

  book.chapters.each do |chapter|
    BakeNonIntroductionPages.v1(chapter: chapter)

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

    BakeChapterGlossary.v1(chapter: chapter, metadata_source: metadata)
    BakeChapterReferences.v3(chapter: chapter, metadata_source: metadata)

    chapter.pages.search('section.review-questions').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(question: question, number: question.count_in(:chapter))
    end

    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      container_key: 'review-questions',
      uuid_key: '.review-questions',
      section_selector: 'section.review-questions',
      wrap_section: true, wrap_content: true
    ) do |section|
      RemoveSectionTitle.v1(section: section)
      title = EocSectionTitleLinkSnippet.v1(page: section.ancestor(:page))
      section.prepend(child: title)
    end

    sections = %w[further-reading]
    sections.each do |section_key|
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

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}")
    end
    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}")
    end
  end

  BakeAutotitledNotes.v1(
    book: book,
    classes: %w[read-philosopher
                think-philosopher
                write-philosopher
                philo-connections
                time-line
                media-video
                media-podcast]
  )

  BakeIframes.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeToc.v1(book: book)
  BakeFolio.v1(book: book)
  BakeRexWrappers.v1(book: book)
  BakeLinks.v1(book: book)
end
