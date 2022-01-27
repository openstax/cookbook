# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeScreenreaderSpans
      # Add text for accessibility.
      # Additional screenreader spans can be added below.
      def self.v1(book:)
        book.search('u[data-effect="underline"]').each do |element|
          add_screenreader_text(
            element: element,
            begin_message: I18n.t(:'screenreader.underline'),
            end_message: "#{I18n.t(:'screenreader.end')} #{I18n.t(:'screenreader.underline')}"
          )
        end
        book.search('u[data-effect="double-underline"]').each do |element|
          add_screenreader_text(
            element: element,
            begin_message: I18n.t(:'screenreader.double-underline'),
            end_message: "#{I18n.t(:'screenreader.end')} #{I18n.t(:'screenreader.double-underline')}"
          )
        end
        book.search('p.public-domain').each do |element|
          add_screenreader_text(
            element: element,
            begin_message: I18n.t(:'screenreader.public-domain'),
            end_message: "#{I18n.t(:'screenreader.end')} #{I18n.t(:'screenreader.public-domain')}"
          )
        end
        book.search('p.student-sample').each do |element|
          add_screenreader_text(
            element: element,
            begin_message: I18n.t(:'screenreader.student-sample'),
            end_message: "#{I18n.t(:'screenreader.end')} #{I18n.t(:'screenreader.student-sample')}"
          )
        end
        book.search('p.annotation-text').each do |element|
          add_screenreader_text(
            element: element,
            begin_message: I18n.t(:'screenreader.annotation-text'),
            end_message: "#{I18n.t(:'screenreader.end')} #{I18n.t(:'screenreader.annotation-text')}"
          )
        end
      end

      def self.add_screenreader_text(element:, begin_message:, end_message:)
        element.prepend(child:
          "<span data-screenreader-only=\"true\">#{begin_message}</span>"
        )
        element.append(child:
          "<span data-screenreader-only=\"true\">#{end_message}</span>"
        )
      end
    end
  end
end
