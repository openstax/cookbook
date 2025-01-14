# frozen_string_literal: true

ADDITIVE_MANUFACTURING_RECIPE = Kitchen::BookRecipe.new(book_short_name: :addman) \
do |doc, _resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  # Some stuff just goes away
  book.search('cnx-pi').trash

  BakeUnnumberedFigure.v1(book: book)
  BakePreface.v1(book: book)

  BakeChapterTitle.v1(book: book)
  BakeChapterIntroductions.v2(
    book: book, options: {
      strategy: :add_objectives, bake_chapter_outline: true
    }
  )

  BakeUnclassifiedNotes.v1(book: book, bake_exercises: true)

  AddInjectedExerciseId.v1(book: book)

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

    BakeChapterGlossary.v2(chapter: chapter)

    eoc_sections = %w[summary
                      review-questions
                      free-response
                      practice]
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
    end

    sections_with_module_links = %w[key-terms]
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

    selectors = 'section.review-questions, section.practice, section.free-response'

    chapter.composite_pages.search(selectors).injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(question: question, number: question.count_in(:chapter))
    end

    answer_key_inner_container = AnswerKeyInnerContainer.v1(
      chapter: chapter, metadata_source: metadata, append_to: answer_key
    )

    exercises = %w[review-questions practice free-response]
    exercises.each do |klass|
      Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
        within: chapter, append_to: answer_key_inner_container, section_class: klass
      )
    end
  end

  AnswerKeyCleaner.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeToc.v1(book: book)
  BakeFolio.v1(book: book)
  BakeLinks.v1(book: book)
end
