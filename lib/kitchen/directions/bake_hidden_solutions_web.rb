# frozen_string_literal: true

module Kitchen::Directions
  module BakeHiddenSolutionsWeb
    def self.v1(book_pages:)
      book_pages.exercises('$.unnumbered').each do |exercise|
        # wrap content, add [Show/Hide Solution] element
        show_hide_translated = 'Show/Hide Solution' # TODO: I18n.t(:problem) - why is this broken?
        solution = exercise.solutions.first
        solution[:'aria-label'] = show_hide_translated
        children = solution.element_children.cut
        solution.append(child:
          <<~HTML
            <summary class="btn-link ui-toggle" title="#{show_hide_translated}" data-content="#{show_hide_translated}">[#{show_hide_translated}]</summary>
            <section class="ui-body" role="alert">#{children.paste}</section>
          HTML
        )
        solution.name = 'details'
      end
    end
  end
end
