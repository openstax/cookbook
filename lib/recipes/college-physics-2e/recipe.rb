# frozen_string_literal: true

COLLEGE_PHYSICS_2E_RECIPE = Kitchen::BookRecipe.new(book_short_name: :college_physics_2e_delete) \
do |doc|
  include Kitchen::Directions

  book = doc.book
  metadata = book.metadata

  book.search('section.ap-test-prep').each(&:trash)

  answer_key = BookAnswerKeyContainer.v1(book: book)

  book.chapters.each do |chapter|
    chapter.sections('$.authentic-assessment').each do |section|
      section.prepend(child:
        <<~HTML
          <h3 data-type="title">#{I18n.t(:"exercises.authentic-assessment")}</h3>
        HTML
      )
      section.exercises.each do |exercise|
        BakeNumberedExercise.v1(
          exercise: exercise, number: exercise.count_in(:section))
        BakeFirstElements.v1(within: exercise)
      end
    end

    chapter.sections('$.problems-exercises').exercises.each do |exercise|
      BakeNumberedExercise.v1(
        exercise: exercise, number: exercise.count_in(:chapter))
      BakeFirstElements.v1(within: exercise)
    end

    answer_key_inner_container = AnswerKeyInnerContainer.v1(
      chapter: chapter, metadata_source: metadata, append_to: answer_key
    )

    classes = %w[problems-exercises]
    classes.each do |klass|
      MoveSolutionsFromExerciseSection.v1(
        chapter: chapter, append_to: answer_key_inner_container, section_class: klass
      )
    end
  end

  BakeCompositeChapters.v1(book: book)
  # Some target labels are created in this stage, but many won't be, so we silence the warning
  silenced do
    BakeLinkPlaceholders.v1(book: book)
  end
end
