# frozen_string_literal: true

module Kitchen
  module Directions
    module BakeScreenreaderSpans
      # Add text for accessibility.
      # Additional screenreader spans can be added below.
      def self.v1(book:)
        book.search('u[data-effect="underline"]').each do |element|
          begin_message = I18n.t(:'screenreader.underline')
          end_message = "#{I18n.t(:'screenreader.end')} #{I18n.t(:'screenreader.underline')}"
          add_screenreader_text(
            element: element,
            begin_message: begin_message,
            end_message: end_message
          )
        end
        book.search('u[data-effect="double-underline"]').each do |element|
          begin_message = I18n.t(:'screenreader.double-underline')
          end_message = "#{I18n.t(:'screenreader.end')} #{I18n.t(:'screenreader.double-underline')}"
          element[:'data-screenreader-begin'] = begin_message
          element[:'data-screenreader-end'] = end_message
          add_screenreader_text(
            element: element,
            begin_message: begin_message,
            end_message: end_message
          )
        end
        book.search('p.public-domain').each do |element|
          begin_message = I18n.t(:'screenreader.public-domain')
          end_message = "#{I18n.t(:'screenreader.end')} #{I18n.t(:'screenreader.public-domain')}"
          element[:'data-screenreader-begin'] = begin_message
          element[:'data-screenreader-end'] = end_message
          add_screenreader_text(
            element: element,
            begin_message: begin_message,
            end_message: end_message
          )
        end
        book.search('p.student-sample').each do |element|
          begin_message = I18n.t(:'screenreader.student-sample')
          end_message = "#{I18n.t(:'screenreader.end')} #{I18n.t(:'screenreader.student-sample')}"
          element[:'data-screenreader-begin'] = begin_message
          element[:'data-screenreader-end'] = end_message
          add_screenreader_text(
            element: element,
            begin_message: begin_message,
            end_message: end_message
          )
        end
        book.search('p.annotation-text').each do |element|
          begin_message = I18n.t(:'screenreader.annotation-text')
          end_message = "#{I18n.t(:'screenreader.end')} #{I18n.t(:'screenreader.annotation-text')}"
          element[:'data-screenreader-begin'] = begin_message
          element[:'data-screenreader-end'] = end_message
          add_screenreader_text(
            element: element,
            begin_message: begin_message,
            end_message: end_message
          )
        end
      end

      def self.add_screenreader_text(element:, begin_message:, end_message:)
        element.prepend(child:
          "<span data-media=\"screenreader\">#{begin_message}</span>"
        )
        element.append(child:
          "<span data-media=\"screenreader\">#{end_message}</span>"
        )
      end
    end
  end
end
