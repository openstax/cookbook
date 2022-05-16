# frozen_string_literal: true

module Kitchen::Directions::MoveSolutionsFromExerciseSection
  def self.v1(chapter:, append_to:, section_class:, title_number: nil, in_appendix: false)
    V1.new.bake(chapter: chapter, append_to: append_to, section_class: section_class,
                title_number: title_number, in_appendix: in_appendix)
  end

  class V1
    def bake(chapter:, append_to:, section_class:, title_number:, in_appendix:)
      solutions_clipboard = chapter.search("section.#{section_class}").solutions.cut

      return if solutions_clipboard.items.empty?

      title_text = \
        if title_number
          I18n.t(:"eoc.#{section_class}", number: title_number)
        elsif in_appendix
          I18n.t(:"appendix_sections.#{section_class}")
        else
          I18n.t(:"eoc.#{section_class}")
        end
      title = <<~HTML
        <h3 data-type="title">
          <span class="os-title-label">#{title_text}</span>
        </h3>
      HTML

      append_to.append(child:
        Kitchen::Directions::SolutionAreaSnippet.v1(
          title: title, solutions_clipboard: solutions_clipboard
        )
      )
    end
  end
end
