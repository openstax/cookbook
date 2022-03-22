# frozen_string_literal: true

module Kitchen::Directions::MoveSolutionsFromNumberedNote
  def self.v1(chapter:, append_to:, note_class:)
    V1.new.bake(chapter: chapter, append_to: append_to, note_class: note_class)
  end

  def self.v2(chapter:, append_to:, note_class:)
    V2.new.bake(chapter: chapter, append_to: append_to, note_class: note_class)
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

  class V2
    def bake(chapter:, append_to:, note_class:)
      return if chapter.notes("$.#{note_class}").solutions.empty?

      notes_title = <<~HTML
        <h3 data-type="title">
          <span class="os-title-label">#{I18n.t(:"notes.#{note_class}")}</span>
        </h3>
      HTML
      append_to.append(child: notes_title)

      solutions_clipboard = Kitchen::Clipboard.new

      # group multiple solutions per exercise
      chapter.notes("$.#{note_class}").each do |note|
        number = "#{chapter.count_in(:book)}.#{note.count_in(:chapter)}"
        solutions_clipboard = note.solutions&.cut

        title = <<~HTML
          <span class="os-note-number">#{number}</span>
        HTML

        append_to.append(child:
          Kitchen::Directions::SolutionAreaSnippet.v1(
            title: title, solutions_clipboard: solutions_clipboard
          )
        )

        solutions_clipboard.clear
      end
    end
  end
end
