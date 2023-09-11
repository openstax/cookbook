# frozen_string_literal: true

ENGLISH_COMPOSITION_RECIPE = Kitchen::BookRecipe.new(book_short_name: :english_composition) \
do |doc, resources|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  # Some stuff just goes away
  book.search('cnx-pi').trash

  BakeImages.v1(book: book, resources: resources)
  BakeUnnumberedFigure.v1(book: book)
  BakePreface.v1(book: book)
  BakeHandbook.v1(book: book)

  BakeChapterTitle.v1(book: book)
  BakeChapterIntroductions.v1(book: book)
  BakeUnitTitle.v1(book: book)
  BakeUnitPageTitle.v1(book: book)

  BakeAnnotationClasses.v1(book: book)

  # Bake EoC sections
  eoc_sections = %w[further-reading works-cited works-consulted]
  eoc_sections.each do |section_key|
    book.chapters.each do |chapter|
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
  end

  book.chapters.each do |chapter|
    chapter.pages.search('section').injected_questions.each do |question|
      BakeInjectedExerciseQuestion.v1(question: question, number: question.count_in(:section))
    end
    BakeLearningObjectives.v1(chapter: chapter)

    chapter.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "#{chapter.count_in(:book)}.#{table.count_in(:chapter)}")
    end

    BakeNonIntroductionPages.v1(chapter: chapter)

    chapter.figures(only: :figure_to_number?).each do |figure|
      BakeFigure.v1(figure: figure,
                    number: "#{chapter.count_in(:book)}.#{figure.count_in(:chapter)}")

    end
  end

  book.pages('$.handbook').each do |page|
    page.tables('$:not(.unnumbered)').each do |table|
      BakeNumberedTable.v1(table: table,
                           number: "H#{table.count_in(:page)}")
    end
  end

  BakeScreenreaderSpans.v1(book: book)
  BakeIframes.v1(book: book)
  BakeStepwise.v1(book: book)
  BakeUnnumberedTables.v1(book: book)
  BakeIndex.v1(book: book)
  BakeCompositePages.v1(book: book)
  BakeCompositeChapters.v1(book: book)
  BakeFootnotes.v1(book: book)
  BakeLinkPlaceholders.v1(book: book)
  BakeToc.v1(book: book)
  BakeFolio.v1(book: book)
  BakeLinks.v1(book: book)

  # Bake Custom Sections
  custom_sections_properties = {
    narrative_trailblazer: {
      class: 'narrative-trailblazer',
      inject: 'title'
    },
    living_words: {
      class: 'living-words',
      inject: 'subtitle'
    },
    quick_launch: {
      class: 'quick-launch',
      inject: 'title_prefix'
    },
    drafting: {
      class: 'drafting',
      inject: 'title_prefix'
    },
    peer_review: {
      class: 'peer-review',
      inject: 'title_prefix'
    },
    revising: {
      class: 'revising',
      inject: 'title_prefix'
    }
  }
  book.chapters.each do |chapter|
    BakeCustomSections.v1(
      chapter: chapter,
      custom_sections_properties: custom_sections_properties
    )
  end
end
