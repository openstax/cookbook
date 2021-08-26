# frozen_string_literal: true

module Kitchen::Directions::MoveSolutionsFromNumberedNote
  def self.v1(chapter:, append_to:, note_class:)
    V1.new.bake(chapter: chapter, append_to: append_to, note_class: note_class)
  end

  class V1
    def bake(chapter:, append_to:, note_class:)
      solutions_clipboard = chapter.notes("$.#{note_class}").solutions.cut

      return if solutions_clipboard.items.empty?

      title = <<~HTML
        <h3 data-type="title">
          <span class="os-title-label">#{I18n.t(:"notes.#{note_class}")}</span>
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
