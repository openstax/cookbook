# frozen_string_literal: true

module Kitchen::Directions::MoveSolutionsFromAutotitledNote
  def self.v1(page:, append_to:, note_class:, title: nil)
    V1.new.bake(page: page, append_to: append_to, note_class: note_class, title: title)
  end

  class V1
    def bake(page:, append_to:, note_class:, title:)
      solutions_clipboard = page.notes("$.#{note_class}").solutions.cut

      return if solutions_clipboard.items.empty?

      if title
        area_title = <<~HTML
          <h3 data-type="title">
            <span class="os-title-label">#{title}</span>
          </h3>
        HTML

        append_to.append(child:
          Kitchen::Directions::SolutionAreaSnippet.v1(
            title: area_title, solutions_clipboard: solutions_clipboard
          )
        )
      else
        append_to.append(child: solutions_clipboard.paste)
      end
    end
  end
end
