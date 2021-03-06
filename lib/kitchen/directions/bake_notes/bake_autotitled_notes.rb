# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeAutotitledNotes
      def self.v1(book:, classes:, options: {
        bake_subtitle: true,
        cases: false,
        bake_exercises: false
      })
        options.reverse_merge!(
          bake_subtitle: true,
          cases: false,
          bake_exercises: false
        )

        book.notes.each do |note|
          next unless (note.classes & classes).any?

          bake_note(
            note: note, options: options)
        end
      end

      def self.bake_note(note:, options: {})
        note.wrap_children(class: 'os-note-body')

        if options[:bake_subtitle]
          BakeNoteSubtitle.v1(note: note, cases: options[:cases])
        else
          note.title&.trash
        end

        note.prepend(child:
          <<~HTML
            <h3 class="os-title" data-type="title">
              <span class="os-title-label">#{note.autogenerated_title}</span>
            </h3>
          HTML
        )

        BakeNoteExercise.v2(note: note) if options[:bake_exercises]
      end
    end
  end
end
