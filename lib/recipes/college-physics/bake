#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../recipes_helper'
require_relative '../college-physics/college_physics_recipe'

college_physics = Kitchen::BookRecipe.new(book_short_name: :college_physics) do |doc, _resources|
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

opts = Slop.parse do |slop|
  slop.string '--input', 'Assembled XHTML input file', required: true
  slop.string '--output', 'Shortened assembled XHTML output file', required: true
  slop.string '--resources', 'Path to book resources directory', required: false
end

puts Kitchen::Oven.bake(
  input_file: opts[:input],
  recipes: [COLLEGE_PHYSICS_RECIPE, college_physics, VALIDATE_OUTPUT],
  output_file: opts[:output],
  resource_dir: opts[:resources] || nil
)
