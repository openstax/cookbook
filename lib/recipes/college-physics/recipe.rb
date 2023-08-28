# frozen_string_literal: true

COLLEGE_PHYSICS_1E_RECIPE = Kitchen::BookRecipe.new(book_short_name: :college_physics) do |doc|
  include Kitchen::Directions

  book = doc.book

  book.chapters.each do |chapter|
    chapter.sections('$.problems-exercises').exercises.each do |exercise|
      BakeNumberedExercise.v1(
        exercise: exercise, number: exercise.count_in(:chapter), options: { suppress_solution_if: true })
    end
    BakeLearningObjectives.v3(chapter: chapter)
  end

end
