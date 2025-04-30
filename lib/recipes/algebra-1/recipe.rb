# frozen_string_literal: true

ALGEBRA_1_RECIPE = Kitchen::BookRecipe.new(book_short_name: :algebra1) do |doc, _resources|
  include Kitchen::Directions
  
  book = doc.book
  book_metadata = book.metadata
  unnumbered_unit_marker = 'data-unnumbered-unit'
  unnumbered_chapter_marker = 'data-unnumbered-chapter'
  
  # Mark unnumbered units and chapters
  book.units.each do |unit|
    title = unit.title.to_s
    is_unnumbered_unit = (
      title.include?('Getting Started') or
      title.include?('Supporting All Learners') or
      title.include?('Research in Practice'))
    if is_unnumbered_unit
      unit[unnumbered_unit_marker] = 'true'
      unit.chapters.each { |ch| ch[unnumbered_chapter_marker] = 'true' }
    else
      unit.chapters.each_with_index do |ch, ch_idx|
        title = ch.title.to_s
        is_unnumbered_chapter = (
          ch_idx == 0 or
          title.include?('Overview and Readiness') or
          title.include?('Project'))
        if is_unnumbered_chapter
          ch[unnumbered_chapter_marker] = 'true'
        end
      end
    end
  end
  # Some stuff just goes away
  book.search('cnx-pi').trash

  BakeUnnumberedFigure.v1(book: book)
  BakeUnclassifiedNotes.v1(book: book)
  BakeIframes.v1(book: book)
  
  AddInjectedExerciseId.v1(book: book)
  book.injected_exercises.each do |exercise|
    BakeInjectedExercise.v1(exercise: exercise)
  end

  notes = %w[
    chapter-objectives
    general-strategies
    link-to-learning
    mini-lesson-question
    self-check
    try
  ]
  BakeAutotitledNotes.v1(book: book, classes: notes)

  # BakeChapterIntroductions.v2(book: book,
  #                           chapters: book.units.chapters,
  #                           options: { numbering_options: { mode: :unit_chapter_page } })
  BakeChapterTitle.v2(chapters: book.units.chapters,
                      numbering_options: { mode: :unit_chapter_page, unit_offset: -2 })

  chapter_numbering_options = {
    unnumbered: { mode: :chapter_page, page_offset: -1 },
    numbered: { mode: :unit_chapter_page, page_offset: -1 }
  }
  chapters_by_type = {
    unnumbered: lambda { book.chapters("$[#{unnumbered_chapter_marker}]") },
    numbered: lambda {
      book.units("$:not([#{unnumbered_unit_marker}])").chapters("$:not([#{unnumbered_chapter_marker}])")
    }
  }

  chapters_by_type[:numbered].call.each do |chapter|
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

  chapters_by_type.keys.each do |chapter_selection|
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
      exercise_sections_or_notes = %w[
        section.practice div[data-type="note"].mini-lesson-question
        div[data-type="note"].mini-lesson-review div[data-type="note"].self-check
      ]
      exercise_sections_or_notes.each do |selector|
        chapter.search(selector).injected_questions.each_with_index do |question, idx|
          BakeInjectedExerciseQuestion.v1(question: question, number: idx + 1)
          BakeFirstElements.v1(within: question)
        end
        # TODO: Delete me?
        chapter.search(selector).exercises.each_with_index do |exercise, idx|
          BakeNumberedExercise.v1(exercise: exercise, number: idx + 1)
        end
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

  BakeStepwise.v1(book: book)
  BakeUnnumberedTables.v1(book: book)

  book.search('section.section-exercises', 'div.os-eob.os-solutions-container').each do |within|
    BakeFirstElements.v1(within: within)
  end

  BakeMathInParagraph.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeUnitTitle.v1(book: book)
  BakeUnitPageTitle.v1(book: book)

  # Remove numbering from page titles in intro chapter pages, unit intro pages,
  # unit closers, unit titles, and chapter titles. 
  (
    book.units("$[#{unnumbered_unit_marker}]").to_a |
    book.units("$[#{unnumbered_unit_marker}]").pages('$:not(.introduction)').to_a |
    book.chapters("$[#{unnumbered_chapter_marker}]").to_a |
    book.chapters("$[#{unnumbered_chapter_marker}]").pages.to_a |
    book.pages('$.unit-closer').to_a
  ).each do |element|
    element.title.replace_children(with: %%<span data-type="" itemprop="" class="os-text">#{element.title_text}</span>%)
  end

  skipped_units = book.units("$[#{unnumbered_unit_marker}]").count - 1
  BakeToc.v1(book: book, options: {
    controller: {
      get_unit_toc_title: lambda do |unit|
        if unit[unnumbered_unit_marker]
          %%<span data-type="" itemprop="" class="os-text">#{unit.title_text}</span>%
        else
          number = unit.os_number({ mode: :unit_chapter_page, unit_offset: -skipped_units })
          <<~HTML
            <span class="os-number"><span class="os-part-text">#{I18n.t(:unit)} </span>#{number}</span>
            <span class="os-divider"> </span>
            <span data-type="" itemprop="" class="os-text">#{unit.title_text}</span>
          HTML
        end
      end,
      get_chapter_toc_title: lambda do |chapter|
        if chapter[unnumbered_chapter_marker]
          %%<span class="os-text" data-type="" itemprop="">#{chapter.title.first!('.os-text').text}</span>%
        else
          unit = chapter.ancestor(:unit)
          skipped_chapters = unit.chapters("$[#{unnumbered_chapter_marker}]").count - 1
          number = chapter.os_number({ mode: :unit_chapter_page, unit_offset: -skipped_units, chapter_offset: -skipped_chapters })
          <<~HTML
            <span class="os-number"><span class="os-part-text">#{I18n.t('chapter')} </span>#{number}</span>
            <span class="os-divider"> </span>
            <span class="os-text" data-type="" itemprop="">#{chapter.title.first!('.os-text').text}</span>
          HTML
        end
      end
    }
  })
  BakeEquations.v1(book: book, number_decorator: :parentheses)
  BakeFolio.v1(book: book, chapters: book.units.chapters, options: { numbering_options: { mode: :unit_chapter_page } })

  book.chapters.each do |chapter|
    BakeLearningObjectives.v2(chapter: chapter)
  end

  BakeRexWrappers.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeLinks.v1(book: book)

  book.chapters("$[#{unnumbered_chapter_marker}]").each do |chapter|
    chapter.remove_attribute(unnumbered_chapter_marker)
  end
  book.units("$[#{unnumbered_unit_marker}]").each do |unit|
    unit.remove_attribute(unnumbered_unit_marker)
  end
end
