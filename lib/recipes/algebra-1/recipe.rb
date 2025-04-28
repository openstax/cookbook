# frozen_string_literal: true

ALGEBRA_1_RECIPE = Kitchen::BookRecipe.new(book_short_name: :raise) do |doc, _resources|
  include Kitchen::Directions
  
  book = doc.book
  book_metadata = book.metadata
  intro_unit_marker = 'data-intro-unit'
  intro_chapter_marker = 'data-intro-chapter'
  
  book.units.each_with_index do |unit, idx|
    if idx < 2
      unit[intro_unit_marker] = 'true'
    end
    unit.chapters.each_with_index do |chapter, ch_idx|
      if ch_idx == 0 or chapter.title.to_s.index(/Project [0-9]+:/) != nil
        chapter[intro_chapter_marker] = 'true'
      end
    end
  end
  # Some stuff just goes away
  book.search('cnx-pi').trash

  BakeUnnumberedFigure.v1(book: book)
  # BakePreface.v1(book: book)
  book.pages('$.preface').each(&:trash)
  BakeUnclassifiedNotes.v1(book: book)
  BakeIframes.v1(book: book)

  # book.notes('$.theorem').each { |theorem| theorem['use-subtitle'] = true }
  notes = %w[
    chapter-objectives
    general-strategies
    link-to-learning
    mini-lesson-question
    self-check
    try
  ]
  BakeAutotitledNotes.v1(book: book, classes: notes)
  # BakeAutotitledNotes.v1(book: book, classes: %w[media-2 problem-solving project])
  # BakeNumberedNotes.v1(book: book, classes: %w[theorem checkpoint])

  # book.chapters.each do |chapter|
    # chapter_review = ChapterReviewContainer.v1(
    #   chapter: chapter,
    #   metadata_source: book_metadata
    # )

    # BakeChapterGlossary.v1(
    #   chapter: chapter, metadata_source: book_metadata, append_to: chapter_review
    # )
    # BakeChapterKeyEquations.v1(
    #   chapter: chapter, metadata_source: book_metadata, append_to: chapter_review
    # )
    # BakeChapterKeyConcepts.v1(
    #   chapter: chapter, metadata_source: book_metadata, append_to: chapter_review
    # )
    # MoveExercisesToEOC.v1(
    #   chapter: chapter, metadata_source: book_metadata,
    #   append_to: chapter_review, klass: 'review-exercises'
    # )
    # BakeChapterSectionExercises.v1(chapter: chapter)

    # Just above we moved the review exercises to the end of the chapter. Now that all of the
    # non-checkpoint exercises are in the right order, we bake them (the "in place" modifications)
    # and number them.
    # chapter.search('section.section-exercises, section.review-exercises').exercises.each \
    # do |exercise|
    #   BakeNumberedExercise.v1(exercise: exercise, number: exercise.count_in(:chapter))
    # end
  # end

  # BakeChapterIntroductions.v2(book: book,
  #                           chapters: book.units.chapters,
  #                           options: { numbering_options: { mode: :unit_chapter_page } })
  BakeChapterTitle.v2(chapters: book.units.chapters, numbering_options: { mode: :unit_chapter_page })

  chapter_numbering_options = {
    intro: { mode: :chapter_page, page_offset: -1 },
    main: { mode: :unit_chapter_page, page_offset: -1 }
  }
  chapters_by_type = {
    intro: lambda { book.chapters("$[#{intro_chapter_marker}]") },
    main: lambda {
      book.units("$:not([#{intro_unit_marker}])").chapters("$:not([#{intro_chapter_marker}])")
    }
  }

  chapters_by_type[:main].call.each do |chapter|
    # chapter_review = ChapterReviewContainer.v1(
    #   chapter: chapter,
    #   metadata_source: book_metadata
    # )

    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: book_metadata,
      container_key: 'key-terms',
      uuid_key: '.key-terms',
      section_selector: 'section.key-terms'
    )    

    # BakeChapterGlossary.v1(
    #   chapter: chapter, metadata_source: book_metadata, append_to: chapter_review
    # )
  end

  [:intro, :main].each do |chapter_selection|
    numbering_options = chapter_numbering_options[chapter_selection]
    chapters = chapters_by_type[chapter_selection].call
    chapters.each do |chapter|
      chapter.tables('$:not(.unnumbered)').each do |table|
        BakeNumberedTable.v1(table: table,
                            number: table.os_number(numbering_options))
      end
  
      chapter.examples.each do |example|
        BakeExample.v1(example: example,
                      number: example.os_number(numbering_options),
                      title_tag: 'h3')
      end
      chapter.figures(only: :figure_to_number?).each do |figure|
        BakeFigure.v1(figure: figure,
                      number: figure.os_number(numbering_options))
      end
      chapter.pages.search('section.practice').exercises.each_with_index do |exercise, idx|
        BakeNumberedExercise.v1(exercise: exercise, number: idx + 1)
      end
      # Title added here
      BakeNonIntroductionPages.v1(chapter: chapter,
                                  options: { numbering_options: numbering_options })
    end
  end

  book.pages('$.appendix').each do |page|
    appendix_letter = [*('A'..'Z')][page.count_in(:book) - 1]

    page.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure, number: "#{appendix_letter}#{figure.count_in(:page)}")
    end

    page.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table, number: "#{appendix_letter}#{table.count_in(:page)}")
    end

    page.examples.each do |example|
      BakeExample.v1(example: example,
                     number: "#{appendix_letter}#{example.count_in(:page)}",
                     title_tag: 'div')
    end

    BakeAppendix.v1(page: page, number: appendix_letter)
  end

  # Here we move the solutions to the end of the book. Calculus has an "Answer Key" composite
  # chapter after the appendices. So we make the answer key, then iterate over the chapters, making
  # an answer key composite page for each chapter that we append to the answer key composite chapter
  # book_answer_key = BookAnswerKeyContainer.v1(book: book)

  # book.units.chapters.each do |chapter|
  #   answer_key_inner_container = AnswerKeyInnerContainer.v1(
  #     chapter: chapter, metadata_source: book_metadata, append_to: book_answer_key
  #   )
  #   # Bake solutions
  #   MoveSolutionsFromAutotitledNote.v1(
  #     page: chapter, append_to: answer_key_inner_container, note_class: 'checkpoint',
  #     title: I18n.t(:'notes.checkpoint')
  #   )
  #   chapter.sections('$.section-exercises').each do |section|
  #     number = "#{chapter.count_in(:book)}.#{section.count_in(:chapter)}"
  #     MoveSolutionsFromExerciseSection.v1(
  #       within: section, append_to: answer_key_inner_container, section_class: 'section-exercises',
  #       title_number: number
  #     )
  #   end
  #   MoveSolutionsFromExerciseSection.v1(
  #     within: chapter, append_to: answer_key_inner_container, section_class: 'review-exercises'
  #   )
  # end

  BakeStepwise.v1(book: book)
  BakeUnnumberedTables.v1(book: book)

  book.search('section.section-exercises', 'div.os-eob.os-solutions-container').each do |within|
    BakeFirstElements.v1(within: within)
  end

  # BakeMathInParagraph.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeUnitTitle.v1(book: book)
  BakeUnitPageTitle.v1(book: book)

  # Remove numbering from page titles in intro chapter pages, unit intro pages,
  # and unit closers. This must happen before BakeToc because The ToC uses these titles
  (
    book.units("$[#{intro_unit_marker}]").pages.to_a |
    book.pages('$.unit-closer').to_a |
    chapters_by_type[:intro].call.pages.to_a
  ).each do |page|
    page.title.replace_children(with: page.title.first!('.os-text').copy.paste)
  end

  BakeToc.v1(book: book, options: {
    numbering_options: { mode: :unit_chapter_page, unit_offset: -2, chapter_offset: -1 },
    controller: {
      get_unit_toc_title: lambda do |unit|
        if unit[:'data-intro-unit']
          %%<span data-type="" itemprop="" class="os-text">#{unit.title_text}</span>%
        end
      end,
      get_chapter_toc_title: lambda do |chapter|
        if chapter[:'data-intro-chapter']
          %%<span class="os-text" data-type="" itemprop="">#{chapter.title.first!('.os-text').text}</span>%
        else
          number = chapter.os_number({ mode: :unit_chapter_page, unit_offset: -2, chapter_offset: -1 })
          <<~HTML
            <span class="os-number"><span class="os-part-text">#{I18n.t('lesson')} </span>#{number}</span>
            <span class="os-divider"> </span>
            <span class="os-text" data-type="" itemprop="">#{chapter.title.first!('.os-text').text}</span>
          HTML
        end
      end
    }
  })
  BakeEquations.v1(book: book, number_decorator: :parentheses)
  BakeFolio.v1(book: book, chapters: book.units.chapters, options: { numbering_options: { mode: :unit_chapter_page } } )

  book.chapters.each do |chapter|
    BakeLearningObjectives.v2(chapter: chapter)
  end

  BakeRexWrappers.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeLinks.v1(book: book)

  book.chapters("$[#{intro_chapter_marker}]").each do |chapter|
    chapter.remove_attribute(intro_chapter_marker)
  end
  book.units("$[#{intro_unit_marker}]").each do |unit|
    unit.remove_attribute(intro_unit_marker)
  end
end
