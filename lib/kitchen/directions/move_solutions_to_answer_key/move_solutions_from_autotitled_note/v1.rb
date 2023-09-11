# frozen_string_literal: true

module Kitchen::Directions::MoveSolutionsFromAutotitledNote
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
