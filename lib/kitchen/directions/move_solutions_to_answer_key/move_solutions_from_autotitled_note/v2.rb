# frozen_string_literal: true

module Kitchen::Directions::MoveSolutionsFromAutotitledNote
  class V2
    def bake(chapter:, append_to:, note_class:)
      append_to.append(child:
        <<~HTML
          <div class="os-module-reset-solution-area os-#{note_class}-solution-area">
            <h3 data-type="title">
              <span class="os-title-label">#{I18n.t(:"notes.#{note_class}")}</span>
            </h3>
          </div>
        HTML
      )
      chapter_solutions_wrapper = append_to.element_children[-1]
      chapter.pages.each do |page|
        solutions_clipboard = page.notes("$.#{note_class}").exercises.solutions&.cut
        next if solutions_clipboard.items.empty?

        title_snippet = Kitchen::Directions::EocSectionTitleLinkSnippet.v1(
          page: page,
          wrapper: 'div'
        )
        chapter_solutions_wrapper.append(
          child: Kitchen::Directions::SolutionAreaSnippet.v1(
            title: title_snippet, solutions_clipboard: solutions_clipboard
          )
        )
      end
    end
  end
end
