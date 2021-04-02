# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeUnclassifiedNotes
      def self.v1(book:)
        book.notes.each do |note|
          next unless note.classes.empty?

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
              <span class="os-title-label" data-type="" id="#{title[:id]}">#{title.children}</span>
            </h3>
          HTML
        )
      end
    end
  end
end
