# frozen_string_literal: true

module Kitchen::Directions::BakeChapterSolutions
  # TODO: Refactor to use EocCompositePageContainer or MoveCustomSectionToEocContainer
  class V1
    renderable

    def bake(chapter:, metadata_source:, uuid_prefix: '')
      @metadata = metadata_source.children_to_keep.copy
      @klass = 'solutions'
      @title = I18n.t(:eoc_solutions_title)
      @uuid_prefix = uuid_prefix

      solutions_clipboard = Kitchen::Clipboard.new

      chapter.search('section.free-response').each do |free_response_question|
        exercises = free_response_question.exercises
        # must run AFTER .free-response notes are baked

        next if exercises.none?

        exercises.each do |exercise|
          solution = exercise.solution
          next unless solution.present?

          solution.cut(to: solutions_clipboard)
        end
      end

      @content = solutions_clipboard.paste

      @in_composite_chapter = false

      chapter.append(child: render(file:
        '../../templates/eoc_section_template_old.xhtml.erb'))
    end
  end
end
