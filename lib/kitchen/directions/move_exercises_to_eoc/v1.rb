# frozen_string_literal: true

module Kitchen::Directions::MoveExercisesToEOC
  class V1
    renderable

    def bake(chapter:, metadata_source:, klass:, append_to: nil, uuid_prefix: '.')
      @klass = klass
      @metadata = metadata_source.children_to_keep.copy
      @title = I18n.t(:"eoc.#{klass}")
      @uuid_prefix = uuid_prefix

      exercise_clipboard = Kitchen::Clipboard.new

      chapter.non_introduction_pages.each do |page|
        sections = page.search("section.#{@klass}")

        sections.each do |exercise_section|
          exercise_section.first("[data-type='title']")&.trash

          exercise_section.exercises.each do |exercise|
            exercise.pantry(name: :link_text).store(
              "#{I18n.t(:exercise_label)} #{chapter.count_in(:book)}.#{exercise.count_in(:chapter)}",
              label: exercise.id
            )
          end

          exercise_section.cut(to: exercise_clipboard)
        end
      end

      return if exercise_clipboard.none?

      @content = exercise_clipboard.paste

      append_to_element = append_to || chapter
      @in_composite_chapter = append_to_element[:'data-type'] == 'composite-chapter'

      append_to_element.append(child: render(file:
        '../../templates/eoc_section_title_template.xhtml.erb'))
    end
  end
end
