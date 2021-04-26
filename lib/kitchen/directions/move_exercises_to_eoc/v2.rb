# frozen_string_literal: true

module Kitchen::Directions::MoveExercisesToEOC
  # Main difference from v1 is the presence of a section title
  # and some additional wrappers
  class V2
    renderable

    def bake(chapter:, metadata_source:, append_to:, klass:)
      @klass = klass
      @metadata = metadata_source.children_to_keep.copy
      @title = I18n.t(:"eoc.#{klass}")

      exercise_clipboard = Kitchen::Clipboard.new

      chapter.non_introduction_pages.each do |page|
        sections = page.search("section.#{@klass}")

        sections.each do |exercise_section|
          exercise_section.first("[data-type='title']")&.trash

          # Get parent page title
          section_title = Kitchen::Directions::EocSectionTitleLinkSnippet.v1(page: page)
          exercise_section.exercises.each do |exercise|
            exercise.pantry(name: :link_text).store(
              "#{I18n.t(:exercise_label)} #{chapter.count_in(:book)}.#{exercise.count_in(:chapter)}",
              label: exercise.id
            )
          end

          # Configure section title & wrappers
          exercise_section.prepend(child: section_title)
          exercise_section.wrap('<div class="os-section-area">')
          exercise_section = exercise_section.parent
          exercise_section.cut(to: exercise_clipboard)
        end
      end

      return if exercise_clipboard.none?

      @content = <<~HTML
        <div class="os-#{@klass}">
          #{exercise_clipboard.paste}
        </div>
      HTML

      append_to.append(child: render(file: 'review_exercises.xhtml.erb'))
    end
  end
end
