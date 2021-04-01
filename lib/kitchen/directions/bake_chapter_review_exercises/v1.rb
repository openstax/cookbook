# frozen_string_literal: true

module Kitchen::Directions::BakeChapterReviewExercises
  class V1
    renderable

    def bake(chapter:, metadata_source:, append_to:)
      @metadata = metadata_source
      @exercise_clipboard = Kitchen::Clipboard.new

      chapter.non_introduction_pages.each do |page|
        sections = page.search('section.review-exercises')

        sections.each do |exercise_section|
          exercise_section.first("[data-type='title']")&.trash

          exercise_section.exercises.each do |exercise|
            exercise.document.pantry(name: :link_text).store(
              "#{I18n.t(:exercise_label)} #{chapter.count_in(:book)}.#{exercise.count_in(:chapter)}",
              label: exercise.id
            )
          end

          exercise_section.cut(to: @exercise_clipboard)
        end
      end

      return if @exercise_clipboard.none?

      append_to.append(child: render(file: 'review_exercises.xhtml.erb'))
    end
  end
end
