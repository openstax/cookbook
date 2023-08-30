# frozen_string_literal: true

ORGANIC_CHEMISTRY_RECIPE = Kitchen::BookRecipe.new(book_short_name: :organic_chemistry) \
do |doc, resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  # Some stuff just goes away
  book.search('cnx-pi').trash

  BakeImages.v1(book: book, resources: resources)
  BakeUnnumberedFigure.v1(book: book)
  BakePreface.v1(book: book)

  AddInjectedExerciseId.v1(book: book)
  book.injected_exercises.each do |exercise|
    BakeInjectedExercise.v1(
      exercise: exercise,
      alphabetical_multiparts: true)
  end

  answer_key_wrapper = BookAnswerKeyContainer.v1(book: book)

  book.chapters.each do |chapter|
    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      container_key: 'chemistry-matters',
      uuid_key: '.chemistry-matters',
      section_selector: 'section.chemistry-matters'
    )

    UseSectionTitle.v1(
      chapter: chapter,
      eoc_selector: '.os-chemistry-matters-container',
      section_selector: 'section.chemistry-matters'
    )

    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      container_key: 'key-terms',
      uuid_key: '.key-terms',
      section_selector: 'section.key-terms'
    )

    BakeChapterKeyEquations.v1(chapter: chapter, metadata_source: metadata)

    sections_without_subtitle = %w[summary summary-reactions]

    sections_without_subtitle.each do |eoc_section|
      MoveCustomSectionToEocContainer.v1(
        chapter: chapter,
        metadata_source: metadata,
        container_key: eoc_section,
        uuid_key: ".#{eoc_section}",
        section_selector: "section.#{eoc_section}"
      ) do |section|
        RemoveSectionTitle.v1(section: section)
      end
    end

    MoveExercisesToEOC.v1(chapter: chapter, metadata_source: metadata,
                          klass: 'visualizing-chemistry')
    MoveExercisesToEOC.v1(chapter: chapter, metadata_source: metadata,
                          klass: 'mechanism-problems')
    MoveExercisesToEOC.v1(chapter: chapter, metadata_source: metadata,
                          klass: 'energy-reaction')
    MoveExercisesToEOC.v1(chapter: chapter, metadata_source: metadata,
                          klass: 'additional-problems')
    MoveExercisesToEOC.v1(chapter: chapter, metadata_source: metadata,
                          klass: 'general-problems')
    BakeChapterSectionExercises.v1(
      chapter: chapter,
      options: {
        trash_title: true,
        create_title: false
      })

    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      container_key: 'practice-scientific',
      uuid_key: '.practice-scientific',
      section_selector: 'section.practice-scientific'
    ) do |section|
      RemoveSectionTitle.v1(section: section)
      title = EocSectionTitleLinkSnippet.v1(page: section.ancestor(:page))
      section.prepend(child: title)
    end

    MoveCustomSectionToEocContainer.v1(
      chapter: chapter,
      metadata_source: metadata,
      container_key: 'preview-carbonylchemistry',
      uuid_key: '.preview-carbonylchemistry',
      section_selector: 'section.preview-carbonylchemistry'
    ) do |section|
      RemoveSectionTitle.v1(section: section)
    end

    exercise_selectors = 'section.section-exercises, section.visualizing-chemistry, ' \
                         'section.mechanism-problems, section.energy-reaction, ' \
                         'section.additional-problems, section.general-problems, ' \
                         'section.preview-carbonylchemistry'

    chapter.search(exercise_selectors).injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(
        question: question,
        number: "#{chapter.count_in(:book)}-#{question.count_in(:chapter)}",
        options: { problem_with_prefix: true }
      )
      BakeFirstElements.v1(within: question)
    end

    # Bake answer key sections
    answer_key_inner_container = AnswerKeyInnerContainer.v1(
      chapter: chapter, metadata_source: metadata, append_to: answer_key_wrapper
    )
    chapter.non_introduction_pages.each do |page|
      page.search('div.os-eos.os-section-exercises-container').each do |section_wrapper|
        Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
          within: section_wrapper, append_to: answer_key_inner_container,
          section_class: 'section-exercises', options: { add_title: false }
        )
      end
    end
    %w[visualizing-chemistry additional-problems preview-carbonylchemistry].each do |klass|
      Kitchen::Directions::MoveSolutionsFromExerciseSection.v1(
        within: chapter, append_to: answer_key_inner_container, section_class: klass,
        options: { add_title: false }
      )
    end
  end

  BakeChapterIntroductions.v1(book: book)
  BakeChapterTitle.v1(book: book)

  book.chapters.each do |chapter|
    BakeLearningObjectives.v1(chapter: chapter)
    BakeNonIntroductionPages.v1(chapter: chapter)

    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}",
                           move_caption_on_top: true,
                           label_class: 'table-target-label')
    end

    chapter.examples.each do |example|
      BakeExample.v1(example: example,
                     number: "#{chapter.count_in(:book)}.#{example.count_in(:chapter)}",
                     title_tag: 'h3')
    end

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}",
                    label_class: 'figure-target-label')
    end
  end

  book.pages('$.appendix').each do |page|
    appendix_letter = [*('A'..'Z')][page.count_in(:book) - 1]

    page.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{appendix_letter}#{figure.count_in(:page)}",
                    label_class: 'figure-target-label')
    end

    page.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{appendix_letter}#{table.count_in(:page)}",
                           move_caption_on_top: true,
                           label_class: 'table-target-label')
    end

    page.examples.each do |example|
      BakeExample.v1(example: example,
                     number: "#{appendix_letter}#{example.count_in(:page)}",
                     title_tag: 'div')
    end

    BakeAppendix.v1(page: page, number: appendix_letter, options: { add_title_label: false })
  end

  BakeUnnumberedTables.v1(book: book)

  book.search('div[data-type="question-solution"]').each do |solution|
    BakeFirstElements.v1(within: solution)
  end

  note_classes = %w[why-chapter chemistry-matters]
  BakeAutotitledNotes.v1(book: book, classes: note_classes)

  BakeCustomTitledNotes.v1(book: book, classes: %w[dedication-page])

  BakeUnclassifiedNotes.v1(book: book)
  BakeStepwise.v1(book: book)
  BakeMathInParagraph.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeToc.v1(book: book)
  # flatten Chemistry Matters section
  book.first!('nav').search('ol.os-chapter').each do |toc_chapter|
    chemistry_matters_link = toc_chapter.first('li.os-toc-chapter-composite-page').first('a')
    chemistry_matters_link.replace_children(with:
      "<span class=\"os-text\">#{chemistry_matters_link.children.text.strip}</span>"
    )
  end
  BakeLinkPlaceholders.v1(book: book, replace_section_link_text: true)
  BakeFolio.v1(book: book, options: { new_approach: true })
  BakeLinks.v1(book: book)
end



