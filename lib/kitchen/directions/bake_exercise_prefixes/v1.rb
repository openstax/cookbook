# frozen_string_literal: true

module Kitchen::Directions::BakeExercisePrefixes
  class V1
    def bake(chapter:, sections_prefixed:)
      sections_prefixed.each do |section_key|
        chapter.composite_pages.each do |composite_page|
          composite_page.search("section.#{section_key}").exercises.each do |exercise|
            problem = exercise.problem
            exercise_prefix =
              "<span class='os-text'>#{I18n.t(:"sections_prefixed.#{section_key}")}</span>"
            problem.prepend(child:
              <<~HTML
                #{exercise_prefix}
              HTML
            )
          end
        end
      end
    end
  end
end
