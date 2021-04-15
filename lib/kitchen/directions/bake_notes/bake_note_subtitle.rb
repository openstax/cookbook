# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeNoteSubtitle
      def self.v1(note:)
        title = note.title&.cut

        return unless title

        title.name = 'h4'
        title.add_class('os-subtitle')
        title.wrap_children('span', class: 'os-subtitle-label')
        note.first!('.os-note-body').prepend(child: title.to_s)
      end
    end
  end
end
