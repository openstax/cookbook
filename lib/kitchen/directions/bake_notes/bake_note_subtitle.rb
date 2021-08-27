# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeNoteSubtitle
      def self.v1(note:, cases: false)
        title = note.title&.cut

        return unless title

        # Store label information
        note_label = title.children
        if cases
          note.target_label(label_text: 'note', custom_content: note_label.to_s, cases: cases)
        else
          note.target_label(custom_content: note_label.to_s)
        end

        title.name = 'h4'
        title.add_class('os-subtitle')
        title.wrap_children('span', class: 'os-subtitle-label')
        note.first!('.os-note-body').prepend(child: title.to_s)
      end
    end
  end
end
