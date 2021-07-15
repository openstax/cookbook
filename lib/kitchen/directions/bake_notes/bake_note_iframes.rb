# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeNoteIFrames
      def self.v1(note:)
        iframes = note.search('iframe')
        return unless iframes.any?

        iframes.each do |iframe|
          iframe.wrap('<div class="os-has-iframe" data-type="alternatives">')
          iframe.add_class('os-is-iframe')
          link_ref = iframe[:src]
          next unless link_ref

          iframe = iframe.parent
          iframe.add_class('os-has-link')
          iframe.prepend(child:
            <<~HTML
              <a class="os-is-link" href="#{link_ref}" target="_window">#{I18n.t(:iframe_link_text)}</a>
            HTML
          )
        end
      end
    end
  end
end
