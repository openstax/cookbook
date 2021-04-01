# frozen_string_literal: true

module Kitchen::Directions::BakeTheorem
  class V1
    def bake(theorem:, number:)
      theorem['use-subtitle'] = true
      new_subtitle = theorem.title.cut

      theorem.wrap_children(class: 'os-note-body')
      note_body = theorem.first('.os-note-body')

      note_body.prepend(sibling:
        <<~HTML
          <div class="os-title">
            <span class="os-title-label">#{I18n.t(:theorem)} </span>
            <span class="os-number">#{number}</span>
            <span class="os-divider"> </span>
          </div>
        HTML
      )

      new_subtitle.name = 'h4'
      new_subtitle.add_class('os-subtitle')
      new_subtitle.children.wrap('<span class="os-subtitle-label">')
      note_body.prepend(child: new_subtitle.paste)
    end
  end
end
