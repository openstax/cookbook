# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeNoteSubtitle
      def self.v1(note:)
        title = note.title&.cut

        return unless title

        # Store label information
        note_label = title.children
        note.pantry(name: :link_text).store note_label, label: note.id

        title.name = 'h4'
        title.add_class('os-subtitle')
        title.wrap_children('span', class: 'os-subtitle-label')
        note.first!('.os-note-body').prepend(child: title.to_s)
      end
    end
  end
end
