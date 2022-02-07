# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeCustomTitledNotes
      # These notes are baked in a similar way to BakeUnclassifiedNotes.
      # They can use existing title or none.
      # Only difference is that they contain classes.

      def self.v1(book:, classes:)
        book.notes.each do |note|
          next unless (note.classes & classes).any?

          bake_note(note: note)
        end
      end

      def self.bake_note(note:)
        note.wrap_children(class: 'os-note-body')

        title = note.title&.cut
        return unless title

        note.prepend(child:
          <<~HTML
            <h3 class="os-title" data-type="title">
              <span class="os-title-label" id="#{title[:id]}">#{title.children}</span>
            </h3>
          HTML
        )
      end
    end
  end
end
